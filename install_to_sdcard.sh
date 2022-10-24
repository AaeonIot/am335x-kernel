if [ -z $1 ]; then
    echo "./install_to_sdcard.sh <sdcard dev>"
    echo "Example: ./install_to_sdcard.sh "sdb""
    exit 0
fi

if [ $(lsblk | grep -c $1) -eq 0 ]; then
    echo "No block device"
    exit 0
fi

if [ $(lsblk | grep $1 | grep -c boot) -eq 0 ]; then
    echo "No boot partition"
    exit 0
fi

if [ $(lsblk | grep $1 | grep -c rootfs) -eq 0 ]; then
    echo "No rootfs partition"
    exit 0
fi

BOOT_PATH=$(lsblk | grep $1 | grep boot | awk '{print $7}')
ROOTFS_PATH=$(lsblk | grep $1 | grep rootfs | awk '{print $7}')
echo "BOOT_PATH: $BOOT_PATH"
echo "ROOTFS_PATH: $ROOTFS_PATH"
sleep 3

echo "make ARCH=arm INSTALL_MOD_PATH=$ROOTFS_PATH/ modules_install"
sudo make ARCH=arm INSTALL_MOD_PATH=$ROOTFS_PATH/ modules_install

echo "cp arch/arm/boot/dts/am335x-srg3352*.dtb $BOOT_PATH/dtbs"
sudo cp arch/arm/boot/dts/am335x-srg3352*.dtb $BOOT_PATH/dtbs

echo "cp arch/arm/boot/zImage $BOOT_PATH/vmlinuz-4.19.94-SRG52x-rt52"
sudo cp arch/arm/boot/zImage $BOOT_PATH/vmlinuz-4.19.94-SRG52x-rt52

echo "sync"
sync

echo "eject storage"
sudo eject /dev/$1

echo "Installation completed"
