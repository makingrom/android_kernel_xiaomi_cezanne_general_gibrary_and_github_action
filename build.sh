#!/bin/bash

sync && echo 3 > /proc/sys/vm/drop_caches

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
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
export CC=clang
# export AS=clang
export LD=ld.lld
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip
export HOSTAR=llvm-ar

# 让 make 不输出颜色 + 不输出冗余日志 → 彻底关闭 stdout 风暴
export TERM=dumb
export LC_ALL=C
export CLANG_FORCE_COLOR_DIAGNOSTICS=0
export KBUILD_VERBOSE=0

# Toolchain paths
# CLANG_PATH="$(pwd)/tools/clang-r383902"
# GCC_PATH="$(pwd)/tools/aarch64-linux-android-4.9"
# export PATH=${CLANG_PATH}/bin:${GCC_PATH}/bin:$PATH
# export LD_LIBRARY_PATH=${CLANG_PATH}/lib64:$LD_LIBRARY_PATH

# proton-clang 工具链
# export CLANG_PATH="$(pwd)/../${AARCH64_LINUX_ANDROID_DIR}"
# export GCC_PATH="$(pwd)/../${AARCH64_LINUX_ANDROID_DIR}"
# export PATH="${CLANG_PATH}/bin:$PATH"
# export LD_LIBRARY_PATH="${CLANG_PATH}/lib64:$LD_LIBRARY_PATH"

# clang-* && GCC 工具链
export CLANG_PATH="$(pwd)/../${CUSTOM_CLANG_DIR}"
export GCC_PATH="$(pwd)/../${CUSTOM_GCC_64_DIR}"
#export GCC_BIN_PATH="${GCC_PATH}/aarch64-linux-android/bin"
#export PATH="${GCC_BIN_PATH}:$PATH"

export PATH="${CLANG_PATH}/bin:${GCC_PATH}/bin:$PATH"
export LD_LIBRARY_PATH="${CLANG_PATH}/lib64:$LD_LIBRARY_PATH"
echo "======================           completed!               ======================"

echo "================================================================================"

echo "  "

# # 关闭报错的联发科视频编解码（VCU/VCODEC）
# sed -i '/CONFIG_MTK_VCODEC/d' arch/${ARCH}/configs/${KERNEL_CONFIG}
# sed -i '/CONFIG_MTK_VCU/d' arch/${ARCH}/configs/${KERNEL_CONFIG}
# sed -i '/CONFIG_VIDEO_MEDIATEK_VCU/d' arch/${ARCH}/configs/${KERNEL_CONFIG}

# echo "CONFIG_MTK_VCODEC=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_VCU=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_VIDEO_MEDIATEK_VCU=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_VCODEC_DEC=n" >> arch/arm64/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_VCODEC_ENC=n" >> arch/arm64/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_VCU_IPC=n" >> arch/arm64/configs/${KERNEL_CONFIG}

# 1. 禁用顶层 Makefile 重复编译 mtk-vcu/ 目录（关键！）
sed -i 's/obj-$(CONFIG_VIDEO_MEDIATEK_VCU)	+= mtk-vcu\/\//' drivers/media/platform/Makefile
sed -i 's/obj-$(CONFIG_VIDEO_MEDIATEK_VCU) += mtk-vcu/\#/' drivers/media/platform/Makefile
# sed -i 's/obj-$(CONFIG_VIDEO_MEDIATEK_VCU) += mtk-vcu.o mtk_vcodec_mem.o\#/' drivers/media/platform/mtk-vcu/Makefile

# 2. 强制保证 mtk-vcodec 能找到 vcu 头文件（解决 undefined symbol）
sed -i '/mtk-vcu/d' drivers/media/platform/mtk-vcodec/Makefile
echo 'ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vcu' >> drivers/media/platform/mtk-vcodec/Makefile

echo "  "

echo -e "\n================================================================================"
echo "======================   Generating default config...    ======================"
make ARCH=arm64 CC=clang HOSTCC=gcc \
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

# # 强制关闭所有冲突的 VCU/VCODEC 配置
# scripts/config --file out/.config --disable MTK_VCU
# scripts/config --file out/.config --disable MTK_VCODEC
# scripts/config --file out/.config --disable MTK_VCODEC_DEC
# scripts/config --file out/.config --disable MTK_VCODEC_ENC
# scripts/config --file out/.config --disable VIDEO_MEDIATEK_VCU

# # 强制 MTK_VCU 只编译进内核，禁止编译成模块（=y 内置，=m 模块）
# scripts/config --file out/.config --set-val MTK_VCU y
# scripts/config --file out/.config --disable MTK_VCU_MODULE
# scripts/config --file out/.config --disable MTK_VCODEC_MODULE

make O=out olddefconfig > /dev/null 2>&1
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
which as
echo $PATH | tr ':' '\n'
as --version
echo "LD = $LD"
echo "LLVM_IAS = $LLVM_IAS"
echo "NM = $NM"
echo "OBJCOPY = $OBJCOPY"
echo "OBJDUMP = $OBJDUMP"
echo "STRIP = $STRIP"
echo "HOSTCC = $HOSTCC"
echo "HOSTAS = $HOSTAS"
echo "HOSTLD = $HOSTLD"
echo "HOSTAR = $HOSTAR"
echo "CLANG_PATH = $CLANG_PATH"
echo "GCC_PATH = $GCC_PATH"
echo "PATH = $PATH"
echo "LD_LIBRARY_PATH = $LD_LIBRARY_PATH"
echo "nproc = $(nproc)"
echo "==============================================================================="
grep -r "MTK_VCU" --include=Kconfig | grep -E "select|default"
echo "==============================================================================="
# 查找所有 Kconfig 里 select / depends on MTK_VCU 的地方
grep -r "MTK_VCU" --include="Kconfig" ./
echo "==============================================================================="
# 查找所有 Makefile 里调用 mtk-vcu 的地方
grep -r "mtk-vcu" --include="Makefile" ./
echo "==============================================================================="
free -h
${CROSS_COMPILE}ld -v
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
