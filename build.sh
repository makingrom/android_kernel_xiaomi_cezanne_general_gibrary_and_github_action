#!/bin/bash

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
export DEFCONFIG=cezanne_user_defconfig
export KERNEL_DIR=$(pwd)
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-androidkernel-
export CC=clang
export LD=ld.lld
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip
export HOSTCC=gcc
export HOSTAR=llvm-ar
# Toolchain paths
CLANG_PATH="$(pwd)/tools/clang-r383902"
GCC_PATH="$(pwd)/tools/aarch64-linux-android-4.9"
export PATH=${CLANG_PATH}/bin:${GCC_PATH}/bin:$PATH
export LD_LIBRARY_PATH=${CLANG_PATH}/lib64:$LD_LIBRARY_PATH
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
    cezanne_user_defconfig
echo "  completed!"

echo -e "\n========================================"
echo "  Applying custom configs..."
echo "========================================"
echo "CONFIG_WERROR=n" >> out/.config
echo "# CONFIG_BLK_INLINE_ENCRYPTION is not set" >> out/.config
echo "CONFIG_BLK_INLINE_ENCRYPTION=n" >> out/.config
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
