#!/bin/bash

# Toolchain paths
CLANG_PATH="$(pwd)/../clang-r437112"
# CLANG_PATH="$(pwd)/../clang-neutron"
GCC_PATH="$(pwd)/../aarch64-linux-android-4.9"
export PATH=${GCC_PATH}/bin:${CLANG_PATH}/bin:$PATH
export LD_LIBRARY_PATH=${CLANG_PATH}/bin64:$LD_LIBRARY_PATH

echo "========================================"
echo "  Cleaning old build files..."
echo "========================================"
make clean O=out
make mrproper O=out
rm -rf out
echo "  completed!"

echo -e "\n========================================"
echo "  Setting environment variables..."
echo "========================================"

export ARCH=arm64
export DEFCONFIG=vendor/cezanne_user_defconfig
export KERNEL_DIR=$(pwd)
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
# export CROSS_COMPILE=aarch64-linux-androidkernel-
export CC=clang
export AS=${cc}
export AR=llvm-ar
export NM=llvm-nm
export LD=ld.lld
#export LLVM_IAS=1
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
CROSS_COMPILE_ARM32=arm-linux-gnueabihf-

echo "  completed!"

echo -e "\n========================================"
echo "  Generating default config..."
echo "========================================"
ARCH=arm64 make CC=clang HOSTCC=gcc \
    AR=llvm-ar NM=llvm-nm \
    OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip \
    O=out CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    LD=ld.lld \
    ${DEFCONFIG}
echo "  completed!"

echo -e "\n========================================"
echo "  Applying custom configs..."
echo "========================================"
# echo "CONFIG_WERROR=n" >> out/.config
# echo "# CONFIG_BLK_INLINE_ENCRYPTION is not set" >> out/.config
# echo "CONFIG_BLK_INLINE_ENCRYPTION=n" >> out/.config

echo "  completed!"

echo -e "\n========================================"
echo "  Starting kernel compilation..."
echo "========================================"
make ARCH=arm64 CC=clang HOSTCC=gcc \
    AR=llvm-ar NM=llvm-nm \
    OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip \
    O=out CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    LD=ld.lld \
    -j4 KCFLAGS="-w"
echo "  Build completed!"

echo -e "\n========================================"
echo "  Collecting all driver modules..."
echo "========================================"
rm -rf out/out_modules
mkdir -p out/out_modules
find out -name "*.ko" -type f -exec cp {} out/out_modules/ \;
echo -e "\n========================================"
echo "  Kernel: out/arch/arm64/boot/Image.gz-dtb"
echo "  All modules: out/out_modules/"
echo "========================================"
