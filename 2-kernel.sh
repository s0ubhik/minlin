source config.sh

fkernel="linux-$KERNEL_VERSION.tar.xz"

fetch_file(){
    link="https://mirrors.edge.kernel.org/pub/linux/kernel/v$KERNEL_VERSION_MAJOR.x/$2"
    blt "Fetching $1..."
    wget $link  -q --show-progress
}

verify_file(){
    bltn "Verifying Downloaded $1..."
    fl_hash=`sha256sum $2 | cut -d ' ' -f1`
    or_hash=`grep $2 linux.asc | cut -d ' ' -f1`
    if [[ "$fl_hash" != "$or_hash"  ]]; then
        echo -e "["$bold$red"FAILED"$ncol"]"
        return 0
    fi
    echo -e "["$bold$green"OK"$ncol"]"
    return 1
}

mkdir -p src
cd src
echo -e "Linux Kernel Version: $bold$yellow$KERNEL_VERSION$ncol"

if [ ! -f $kernel/.extracted ];then

    if [ ! -f linux.asc ]; then
        blt "Fetching Hashes..."
        wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/sha256sums.asc -q --show-progress -O linux.asc
    fi

    while [ ! -f "$fkernel" ] || verify_file "Kernel" $fkernel; do
        fetch_file "Kernel" $fkernel
    done

    blt "Extracting..."
    tar -xf "$kernel.tar.xz"
    touch $kernel/.extracted
fi

blt "Configuring..."
cd $kernel
make defconfig

blt "Building..."
make -j8 || exit

cd ../../
blt "Coping bzImage to build/"
cp src/$kernel/arch/x86/boot/bzImage build/
