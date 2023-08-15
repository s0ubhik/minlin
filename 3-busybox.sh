source config.sh

bblink="https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2"

fbusyb="busybox-$BUSYBOX_VERSION.tar.bz2"
bbv=`echo $BUSYBOX_VERSION | grep -oP '\d+\.\d+\.\d+' | tr -d '.'`


if [ "$bbv" -gt "1272" ]; then
    slink="$bblink.sha256"
    fsign="busybox-$BUSYBOX_VERSION.tar.bz2.sha256"
else
    slink="$bblink.sign"
    fsign="busybox-$BUSYBOX_VERSION.tar.bz2.sign"
fi


fetch_bb(){
    blt "Fetching BusyBox..."
    wget $bblink  -q --show-progress
}

verify_bb(){
    if [ "$bbv" -gt "1272" ]; then
        verify_bb_tp2
    else
        verify_bb_tp1
    fi
}

verify_bb_tp1(){
    bltn "Verifying Downloaded BusyBox..."
    fl_hash=`md5sum $fbusyb | cut -d ' ' -f1`
    or_hash=`grep MD5 $fsign | cut -d ' ' -f3`
    if [[ "$fl_hash" != "$or_hash"  ]]; then
        echo -e "["$bold$red"FAILED"$ncol"]"
        return 0
    fi
    echo -e "["$bold$green"OK"$ncol"]"
    return 1
}


verify_bb_tp2(){
    bltn "Verifying Downloaded BusyBox..."
    fl_hash=`sha256sum $fbusyb | cut -d ' ' -f1`
    or_hash=`cat $fsign | cut -d ' ' -f1`
    if [[ "$fl_hash" != "$or_hash"  ]]; then
        echo -e "["$bold$red"FAILED"$ncol"]"
        return 0
    fi
    echo -e "["$bold$green"OK"$ncol"]"
    return 1
}


mkdir -p src
cd src
echo -e "BusyBox Version: $bold$yellow$BUSYBOX_VERSION$ncol"

if [ ! -f $fsign ]; then
    blt "Fetching Hashes..."
    wget $slink -q --show-progress
fi

while [ ! -f "$fbusyb" ] || verify_bb; do
    fetch_bb 
done


blt "Extracting..."
tar -xf "$busybox.tar.bz2"

cd $busybox

blt "Configuring..."

make defconfig
sed 's/^.*CONFIG_STATIC.*$/CONFIG_STATIC=y/g' -i .config
sed 's/^.*CONFIG_FEATURE_USE_INITTAB.*$/CONFIG_FEATURE_USE_INITTAB=n/g' -i .config
echo "" | make oldconfig

blt "Building..."
# debian based
make -j8 busybox
# arch bases systems
# make CC=musl-gcc -j8