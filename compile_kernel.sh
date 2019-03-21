#!/bin/bash

first_time=$1

if [ "$first_time" == "i" ] || [ "$first_time" == "I" ] || [ "$first_time" == "initial" ] || [ "$first_time" == "INITIAL" ] || [ "$first_time" == "Initial" ] ; then
    echo "Running script for the first time in this folder"
    echo -e
    mkdir -p $DEVDIR/images/modules 
    mkdir -p $DEVDIR/images/packages
    mkdir -p $DEVDIR/images/dtb
fi

export DEVDIR=$(pwd)
export CROSS_COMPILE=/opt/l4t-gcc-toolchain-64-bit-28.2.1/gcc-linaro-6.4.1-2017.08-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu- #Change as per your path for cross compile tool chain 
export KERNEL_MODULES_OUT=$DEVDIR/images/modules
export TEGRA_KERNEL_OUT=$DEVDIR/images
export ARCH=arm64

cd $DEVDIR/sources/kernel/kernel-4.4
make mrproper

make O=$TEGRA_KERNEL_OUT tegra18_defconfig
echo "Choose what to build"
echo 
make O=$TEGRA_KERNEL_OUT menuconfig # Here, choose required settings

echo "Make zimage"
echo 
make -j$(nproc) O=$TEGRA_KERNEL_OUT zImage
echo "Make dtb\n"
echo 
make -j$(nproc) O=$TEGRA_KERNEL_OUT dtbs
echo "Make modules\n"
echo 
make -j$(nproc) O=$TEGRA_KERNEL_OUT modules
echo "Make modules_install\n"
echo 
make -j$(nproc) O=$TEGRA_KERNEL_OUT modules_install INSTALL_MOD_PATH=$KERNEL_MODULES_OUT

export KERNEL_MODULES_NAME=4.4.38+

cd $DEVDIR/images/modules/lib/modules/$KERNEL_MODULES_NAME
rm build source

echo "Create Tarball"
echo
cd $DEVDIR/images/modules/
tar -cjf kernel_supplements.tbz2 *
mv kernel_supplements.tbz2 $DEVDIR/images/packages

cd $DEVDIR/kernel
tar -xf kernel_headers.tbz2
if [ "$first_time" == "i" ] || [ "$first_time" == "I" ] || [ "$first_time" == "initial" ] || [ "$first_time" == "INITIAL" ] || [ "$first_time" == "Initial" ] ; then
    export KERNEL_HEADERS_NAME=linux-headers-4.4.38-tegra
    mv $KER
    NEL_HEADERS_NAME linux-headers-$KERNEL_MODULES_NAME
fi
tar -cjf kernel_headers_custom.tbz2 linux-headers-$KERNEL_MODULES_NAME
mv kernel_headers_custom.tbz2 $DEVDIR/images/packages
rm -rf linux-headers-$KERNEL_MODULES_NAME 

echo "Moving device trees"
echo
cp $DEVDIR/images/arch/arm64/boot/dts/tegra186-quill-p3310-1000-c03-00-base.dtb $DEVDIR/kernel/dtb

cd $DEVDIR/images
cp -rf arch/arm64/boot/Image arch/arm64/boot/zImage packages/kernel_supplements.tbz2 $DEVDIR/kernel/
cp -rf packages/kernel_headers_custom.tbz2 $DEVDIR/kernel/kernel_headers.tbz2

cd $DEVDIR/
sudo ./apply_binaries.sh 