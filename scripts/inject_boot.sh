#!/sbin/sh
BUSYBOX="/tmp/multirom/busybox"
BOOT_DEV="/dev/block/platform/sdhci-tegra.3/by-name/LNX"


dd if=$BOOT_DEV of=/tmp/boot.img
/tmp/unpackbootimg -i /tmp/boot.img -o /tmp/
if [ ! -f /tmp/boot.img-zImage ] ; then
    echo "Failed to extract boot.img"
    return 1
fi

rm -r /tmp/boot
mkdir /tmp/boot

cd /tmp/boot
$BUSYBOX gzip -d -c ../boot.img-ramdisk.gz | $BUSYBOX cpio -i
if [ ! -f /tmp/boot/init ] ; then
    echo "Failed to extract ramdisk!"
    return 1
fi

# copy trampoline
if [ ! -e /tmp/boot/main_init ] ; then 
    mv /tmp/boot/init /tmp/boot/main_init
fi
cp /tmp/multirom/trampoline /tmp/boot/init
chmod 750 /tmp/boot/init

# crete ueventd symlink
if [ -L /tmp/boot/sbin/ueventd ] ; then
    ln -sf ../main_init /tmp/boot/sbin/ueventd
fi

# pack the image again
cd /tmp/boot
find . | $BUSYBOX cpio -o -H newc | $BUSYBOX gzip > ../boot.img-ramdisk.gz

cd /tmp
/tmp/mkbootimg --kernel boot.img-zImage --ramdisk boot.img-ramdisk.gz --cmdline "$(cat boot.img-cmdline)" --base $(cat boot.img-base) --output /tmp/newboot.img

if [ ! -e "/tmp/newboot.img" ] ; then
    echo "Failed to inject boot.img!"
    return 1
fi

echo "Writing new boot.img..."
dd bs=4096 if=/tmp/newboot.img of=$BOOT_DEV
return $?