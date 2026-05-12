#!/bin/bash


echo "================================================================================"
echo "=======================  Cleaning old build files...   ========================="
# 编译生成文件配置
# 低端机填Image.gz-dtb，高端机可以选择Image.gz，Image
export KERNEL_IMAGE_NAME=Image.gz-dtb
# 是否 上传MTK驱动模块.ko文件
export MTK_KERNEL_MODULES_UPLOAD=false
#打包上传生成的三个Image文件
export KERNEL_ALL_IMAGE_UPLOAD=false
# 是否 需要dtbo，一般不需要，false即可
export NEED_DTBO=false
# 是否 编译完整的 boot.img
export BUILD_BOOT_IMG=false
# 原始 boot.img 的下载地址（用于拼接内核镜像生成新 boot.img）
export SOURCE_BOOT_IMAGE=https://raw.githubusercontent.com/makingrom/LXC-DOCKER-KernelSU_Action/refs/heads/main/boot/boot.img
echo "================================================================================"
echo "KERNEL_IMAGE_NAME=${KERNEL_IMAGE_NAME}" >> $GITHUB_ENV
echo "MTK_KERNEL_MODULES_UPLOAD=${MTK_KERNEL_MODULES_UPLOAD}" >> $GITHUB_ENV
echo "KERNEL_ALL_IMAGE_UPLOAD=${KERNEL_ALL_IMAGE_UPLOAD}" >> $GITHUB_ENV
echo "NEED_DTBO=${NEED_DTBO}" >> $GITHUB_ENV
echo "BUILD_BOOT_IMG=${BUILD_BOOT_IMG}" >> $GITHUB_ENV
echo "SOURCE_BOOT_IMAGE=${SOURCE_BOOT_IMAGE}" >> $GITHUB_ENV
echo "=======================           completed!             ======================="
echo "================================================================================"

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
# export CROSS_COMPILE=aarch64-linux-androidkernel-
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
export CC=clang
export AS="clang -fintegrated-as"
export HOSTCC=gcc
export LLVM_IAS=1
export LD=ld.lld
export AR=llvm-ar
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

# proton-clang 工具链
# export CLANG_PATH="$(pwd)/../${GCC_AND_CLANG_DIR}"
# export GCC_PATH="$(pwd)/../${GCC_AND_CLANG_DIR}"
# export PATH="${CLANG_PATH}/bin:$PATH"
# export LD_LIBRARY_PATH="${CLANG_PATH}/lib64:$LD_LIBRARY_PATH"

# clang-* && GCC 工具链

#export GCC_BIN_PATH="${GCC_PATH}/aarch64-linux-android/bin"
#export PATH="${GCC_BIN_PATH}:$PATH"


export CLANG_PATH="$(pwd)/../${CUSTOM_CLANG_DIR}"
export GCC_PATH="$(pwd)/../${CUSTOM_GCC_64_DIR}"
export PATH="${CLANG_PATH}/bin:${GCC_PATH}/bin:$PATH"
export LD_LIBRARY_PATH="${CLANG_PATH}/lib64:$LD_LIBRARY_PATH"

echo "======================           completed!               ======================"

echo "================================================================================"

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "======================   Generating default config...    ======================"
make LLVM_IAS=${LLVM_IAS} ARCH=${ARCH} CC=${CC} HOSTCC=${HOSTCC} \
    AS=${AS} AR=${AR} NM=${NM} \
    OBJCOPY=${OBJCOPY} OBJDUMP=${OBJDUMP} STRIP=${STRIP} \
    O=out CLANG_TRIPLE=${CLANG_TRIPLE} \
    CROSS_COMPILE=${CROSS_COMPILE} \
    LD=${LD} \
    ${DEFCONFIG}
echo "=========================         completed!           ========================="
echo "================================================================================"

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "=========================  Applying custom configs...  ========================="
echo "CONFIG_WERROR=n" >> out/.config
echo "# CONFIG_BLK_INLINE_ENCRYPTION is not set" >> out/.config
echo "CONFIG_BLK_INLINE_ENCRYPTION=n" >> out/.config

if [ ${NEED_DTBO} = "true" ]; then
    # echo "CONFIG_OF_OVERLAY=y" >> out/.config
    # echo "CONFIG_OF_DTB_OVERLAY_SUPPORT=y" >> out/.config
    echo "CONFIG_BUILD_ARM64_DTBO_IMAGES=y" >> out/.config
    echo "CONFIG_DTBO_ENABLE=y" >> out/.config
    echo "CONFIG_BUILD_ARM64_DTBO_IMAGES = ${CONFIG_BUILD_ARM64_DTBO_IMAGES}"
    echo "CONFIG_DTBO_ENABLE = ${CONFIG_DTBO_ENABLE}"
else
    # echo "CONFIG_OF_OVERLAY=n" >> out/.config
    # echo "CONFIG_OF_DTB_OVERLAY_SUPPORT=n" >> out/.config
    echo "CONFIG_BUILD_ARM64_DTBO_IMAGES=n" >> out/.config
    echo "CONFIG_DTBO_ENABLE=n" >> out/.config
    echo "CONFIG_BUILD_ARM64_DTBO_IMAGES = ${CONFIG_BUILD_ARM64_DTBO_IMAGES}"
    echo "CONFIG_DTBO_ENABLE = ${CONFIG_DTBO_ENABLE}"
fi

echo "==============================      completed!    =============================="
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
which as
echo $PATH | tr ':' '\n'
as --version
echo "LD = $LD"
echo "HOSTCC = $HOSTCC"
echo "AR = $AR"
echo "NM = $NM"
echo "LLVM_IAS = $LLVM_IAS"
echo "OBJCOPY = $OBJCOPY"
echo "OBJDUMP = $OBJDUMP"
echo "STRIP = $STRIP"
echo "HOSTCC = $HOSTCC"
echo "HOSTAS = $HOSTAS"
echo "HOSTLD = $HOSTLD"
echo "HOSTAR = $HOSTAR"
echo "CLANG_FLAGS = $CLANG_FLAGS"
echo "CFLAGS = $CFLAGS"
echo "==============================================================================="
echo "CLANG_PATH = $CLANG_PATH"
echo "GCC_PATH = $GCC_PATH"
echo "PATH = $PATH"
echo "LD_LIBRARY_PATH = $LD_LIBRARY_PATH"
echo "==============================================================================="
echo "nproc = $(nproc)"
# 查找所有 Makefile 里调用 mtk-vcu 的地方
# grep -r "mtk-vcu" --include="Makefile" ./
free -h
${CROSS_COMPILE}ld -v
ld.lld --version
echo "==============================================================================="

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "======================  Starting kernel compilation...  ======================="
make LLVM_IAS=${LLVM_IAS} ARCH=${ARCH} CC=${CC} HOSTCC=${HOSTCC} \
    AS=${AS} AR=${AR} NM=${NM} \
    OBJCOPY=${OBJCOPY} OBJDUMP=${OBJDUMP} STRIP=${STRIP} \
    O=out CLANG_TRIPLE=${CLANG_TRIPLE} \
    CROSS_COMPILE=${CROSS_COMPILE} \
    LD=${LD} \
    -j4 KCFLAGS="-w"
echo "=========================      Build completed!        ========================="
echo "================================================================================"

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "======================  Collecting all driver modules...  ======================"
rm -rf out/out_modules
rm -rf out/out_Image
mkdir -p out/out_modules
mkdir -p out/out_Image
find out -name "*.ko" -type f -exec cp {} out/out_modules/ \;
cp out/arch/arm64/boot/Image* out/out_Image/
echo "================================================================================"

echo "  "
echo "  "

echo -e "\n================================================================================"
echo "================== Kernel: out/arch/arm64/boot/Image.gz-dtb  =================="
echo "=======================  All modules: out/out_modules/  ========================"
echo "=======================  All Image: out/out_Image/  ========================"
echo "================================================================================"
