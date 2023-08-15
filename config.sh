source painter.sh

KERNEL_VERSION=5.13.12

BUSYBOX_VERSION=1.34.1

KERNEL_VERSION_MAJOR=$(echo $KERNEL_VERSION | sed 's/\([0-9]*\)[^0-9].*/\1/')
kernel="linux-$KERNEL_VERSION"
busybox="busybox-$BUSYBOX_VERSION"
mkdir -vp build
