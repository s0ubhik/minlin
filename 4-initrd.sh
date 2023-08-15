source config.sh
rm -rf build/initrd

blt "Extracting Base initrd..."
cd src
  tar -xf initrd.tar
cd ..


blt "Copying rootfs..."
cp -r src/initrd build/


blt "Coping busybox to /bin..."
cp src/$busybox/busybox build/initrd/bin

cd build/initrd/bin
  blt "Creating symlinks for utils..."
  for prog in $(./busybox --list); do
    ln -s ./busybox ./$prog
  done
cd .. # build/initrd

blt "Creating initrd.img... "
echo -n "Wrote: "
find . | cpio -o -H newc > ../initrd.img

cd .. # build/
rm -rf initrd
