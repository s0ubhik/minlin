# qemu window
qemu-system-x86_64 -kernel build/bzImage -initrd build/initrd.img

# boot in console
# qemu-system-x86_64 -kernel build/bzImage -initrd build/initrd.img -nographic -append 'console=ttyS0 sample=text'
