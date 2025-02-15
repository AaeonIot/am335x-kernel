#!/bin/bash

#gcc:

#
#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.05/arm-linux-gnueabihf/gcc-linaro-7.1.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz
#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.08/arm-linux-gnueabihf/gcc-linaro-7.1.1-2017.08-x86_64_arm-linux-gnueabihf.tar.xz
#https://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/arm-linux-gnueabihf/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf.tar.xz
#https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz
#https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/arm-linux-gnueabihf/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf.tar.xz
#https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
#

gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/"
gcc_filename_prefix="gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf"
gcc_banner="arm-linux-gnueabihf-gcc (Linaro GCC 7.5-2019.12) 7.5.0"
gcc_copyright="2017"
datestamp="2019.12-gcc-arm-linux-gnueabihf"

# sophie 2020.1.13
# https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz

#

if [ ! -d ${gcc_filename_prefix}/ ] ; then
	rm -rf ./gcc-* || true
	#wget -c ${site}/${version}/${filename}
	#wget -c http://gfnd.rcn-ee.org/farm/jenkins-dl/${gcc_filename_prefix}.tar.xz
	wget -c https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
	tar xf ${gcc_filename_prefix}.tar.xz
fi

export CC=`pwd`/${gcc_filename_prefix}/bin/arm-linux-gnueabihf-

# make ARCH=arm clean
make ARCH=arm srg52_defconfig

# echo "[make ARCH=arm -j4 CROSS_COMPILE=\"${binary}\" zImage]"
echo "[make ARCH=arm -j4 CROSS_COMPILE=\"ccache ${CC}\" zImage]"
make ARCH=arm -j4 CROSS_COMPILE="ccache ${CC}" zImage
if [ ! -f arch/arm/boot/zImage ] ; then
	echo "failed: [arch/arm/boot/zImage]"
	exit 1
fi

# echo "[make ARCH=arm -j4 CROSS_COMPILE=\"${binary}\" modules]"
echo "[make ARCH=arm -j4 CROSS_COMPILE=\"ccache ${CC}\" modules]"
make ARCH=arm -j4 CROSS_COMPILE="ccache ${CC}" modules
if [ ! -f drivers/spi/spidev.ko ] ; then
	echo "failed: [drivers/spi/spidev.ko]"
	exit 1
fi

# echo "[make ARCH=arm CROSS_COMPILE=\"${binary}\" dtbs]"
echo "[make ARCH=arm CROSS_COMPILE=\"ccache ${CC}\" dtbs]"
make ARCH=arm CROSS_COMPILE="ccache ${CC}" dtbs
if [ ! -f arch/arm/boot/dts/am335x-srg3352.dtb ] ; then
	echo "failed: [arch/arm/boot/dts/am335x-srg3352.dtb]"
	exit 1
fi

# make ARCH=arm clean
# make ARCH=arm install /media/aaa/rootfs

