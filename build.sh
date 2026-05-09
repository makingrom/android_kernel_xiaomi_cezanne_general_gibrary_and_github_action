#!/bin/bash

echo "================================================================================"
echo "=======================  Cleaning old build files...   ========================="
make clean O=out
make mrproper O=out
make mrproper
rm -rf out
echo "=======================           completed!             ======================="
echo "================================================================================"

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "=======================  Setting environment variables...  ====================="
export ARCH=arm64
export DEFCONFIG=cezanne_user_defconfig
export KERNEL_DIR=$(pwd)
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-androidkernel-
export CC=clang
export AS=clang
export LD=ld.lld
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip
export HOSTCC=gcc
export HOSTAR=llvm-ar

# Toolchain paths
# CLANG_PATH="$(pwd)/tools/clang-r383902"
# GCC_PATH="$(pwd)/tools/aarch64-linux-android-4.9"
# export PATH=${CLANG_PATH}/bin:${GCC_PATH}/bin:$PATH
# export LD_LIBRARY_PATH=${CLANG_PATH}/lib64:$LD_LIBRARY_PATH
export CLANG_PATH="$(pwd)/${AARCH64_LINUX_ANDROID_DIR}"
export GCC_PATH="$(pwd)/${AARCH64_LINUX_ANDROID_DIR}"
export PATH="${CLANG_PATH}/bin:$PATH"
export LD_LIBRARY_PATH="${CLANG_PATH}/lib:$LD_LIBRARY_PATH"
echo "======================           completed!               ======================"
echo "================================================================================"

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "======================   Generating default config...    ======================"
ARCH=arm64 make CC=clang HOSTCC=gcc \
    AR=llvm-ar NM=llvm-nm \
    OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip \
    O=out CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    LD=ld.lld \
    cezanne_user_defconfig
echo "=========================         completed!           ========================="
echo "================================================================================"

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "=========================  Applying custom configs...  ========================="
echo "CONFIG_WERROR=n" >> out/.config
echo "# CONFIG_BLK_INLINE_ENCRYPTION is not set" >> out/.config
echo "CONFIG_BLK_INLINE_ENCRYPTION=n" >> out/.config
echo "  completed!"
echo "================================================================================"

echo "  "
echo "  "

echo -e "\n==============================================================================="
echo -e "\n=========================          调试信息          =========================="
echo "ARCH = $ARCH"
echo "DEFCONFIG = $DEFCONFIG"
echo "KERNEL_DIR = $KERNEL_DIR"
echo "CLANG_TRIPLE = $CLANG_TRIPLE"
echo "CROSS_COMPILE = $CROSS_COMPILE"
echo "CC = $CC"
echo "AS = $AS"
echo "LD = $LD"
echo "NM = $NM"
echo "OBJCOPY = $OBJCOPY"
echo "OBJDUMP = $OBJDUMP"
echo "STRIP = $STRIP"
echo "HOSTCC = $HOSTCC"
echo "HOSTAR = $HOSTAR"
echo "CLANG_PATH = $CLANG_PATH"
echo "GCC_PATH = $GCC_PATH"
echo "PATH = $PATH"
echo "LD_LIBRARY_PATH = $LD_LIBRARY_PATH"
ld.lld --version
echo "==============================================================================="

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "======================  Starting kernel compilation...  ======================="
make ARCH=arm64 CC=clang HOSTCC=gcc \
    AR=llvm-ar NM=llvm-nm \
    OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip \
    O=out CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    LD=ld.lld \
    -j4 KCFLAGS="-w"
echo "=========================      Build completed!        ========================="
echo "================================================================================"

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "======================  Collecting all driver modules...  ======================"
rm -rf out/out_modules
mkdir -p out/out_modules
find out -name "*.ko" -type f -exec cp {} out/out_modules/ \;
echo "================================================================================"

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "================== Kernel: out/arch/arm64/boot/Image.gz-dtb  =================="
echo "=======================  All modules: out/out_modules/  ========================"
echo "================================================================================"
