#!/bin/bash


echo "================================================================================"
echo "=======================  Cleaning old build files...   ========================="
# 编译生成文件配置
# 固定内核版本
SUBLEVEL = 186
LOCALVERSION =
# 低端机填Image.gz-dtb，高端机可以选择Image.gz，Image
export KERNEL_IMAGE_NAME=Image.gz-dtb
# 是否 上传MTK驱动模块.ko文件
export MTK_KERNEL_MODULES_UPLOAD=true
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
# # 先清空可能重复的模块配置
# sed -i '/CONFIG_MTK_COMBO/d' arch/${ARCH}/configs/${KERNEL_CONFIG}
# sed -i '/CONFIG_MTK_COMBO_CHIP_CONSYS_6885/d' >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# sed -i '/CONFIG_WLAN_DRV_BUILD_IN/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_DEFAULT_CUBIC/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_MTK_COMBO_WLAN/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_MTK_COMBO_BT/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_MTK_COMBO_FM/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_MTK_COMBO_GPS/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_MTK_FPSGO/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_MTK_MET_DRV/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_MTK_MET_PLF/d' >> arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_MTK_MET_BUILT_IN/d' >> arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
# sed -i '/CONFIG_MTK_UDC/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null


# # 编译驱动总开关配置 y/m/n
# echo "CONFIG_MTK_COMBO=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_COMBO_CHIP_CONSYS_6885=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_WLAN_DRV_BUILD_IN=m" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_DEFAULT_CUBIC=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# # 再写入正确配置（内置模式）y/m/n
# echo "CONFIG_MTK_COMBO_WLAN=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_COMBO_BT=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_COMBO_FM=m" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_COMBO_GPS=m" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_FPSGO=m" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_MET_DRV=m" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_MET_PLF=m" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_MET_BUILT_IN=m" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
# echo "CONFIG_MTK_UDC=m" >> arch/${ARCH}/configs/${KERNEL_CONFIG}

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
export AS=$cc
export HOSTCC=gcc
export LLVM_IAS=1
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip
export HOSTAR=llvm-ar
# make LLVM_IAS=1 ARCH=arm64 CC=clang HOSTCC=gcc \
#     AS=clang AR=llvm-ar NM=llvm-nm \
#     OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip \
#     O=out CLANG_TRIPLE=aarch64-linux-gnu- \
#     CROSS_COMPILE=aarch64-linux-android- \
#     LD=ld.lld \
#     ${DEFCONFIG}

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


# sed -i '/struct task_struct {/a \ \ int cpu_prefer;' include/linux/sched.h
# echo "#define SCHED_PREFER_NONE 0" >> include/linux/sched.h
# sed -i 's/^int cpu_prefer;$//g' include/linux/sched.h
# sed -i 's/-mgeneral-regs-only//' drivers/power/supply/ti_cezanne/Makefile
# sed -i 's/extern inline int typec_pd_start_entry/int typec_pd_start_entry/' drivers/misc/mediatek/typec/tcpc_cezanne/inc/tcpci_typec.h

# # 是否 将内核自带的模块编译进内核
# echo "CONFIG_LCD_CLASS_DEVICE=y" >> out/.config
# echo "CONFIG_IKHEADERS=y" >> out/.config
# echo "CONFIG_BRIDGE_NETFILTER=y" >> out/.config
# echo "CONFIG_TCP_CONG_WESTWOOD=y" >> out/.config
# echo "CONFIG_TCP_CONG_HTCP=y" >> out/.config

# # 写入到 out/.config（严格按你的要求）
# echo "CONFIG_MTK_COMBO=y" >> out/.config
# echo "CONFIG_MTK_COMBO_CHIP_CONSYS_6885=y" >> out/.config
# echo "CONFIG_WLAN_DRV_BUILD_IN=y" >> out/.config
# echo "CONFIG_DEFAULT_CUBIC=y" >> out/.config
# echo "CONFIG_MTK_COMBO_WLAN=y" >> out/.config
# echo "CONFIG_MTK_COMBO_BT=y" >> out/.config
# echo "CONFIG_MTK_COMBO_FM=y" >> out/.config
# echo "CONFIG_MTK_COMBO_GPS=y" >> out/.config
# echo "CONFIG_MTK_FPSGO=y" >> out/.config
# echo "CONFIG_MTK_MET_DRV=y" >> out/.config
# echo "CONFIG_MTK_MET_PLF=y" >> out/.config
# echo "CONFIG_MTK_MET_BUILT_IN=y" >> out/.config
# echo "CONFIG_MTK_UDC=y" >> out/.config
# echo "MTK_GPS_REGISTER_SETTING=y" >> out/.config
# echo "MTK_GPS_EMI=y" >> out/.config

# # 芯片型号
# echo "CONFIG_MTK_COMBO_CHIP_CONSYS_6885=y" >> out/.config

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

# 编译提示新的选项使用oldconfig默认选项
yes "" |　make LLVM_IAS=${LLVM_IAS} ARCH=${ARCH} CC=${CC} HOSTCC=${HOSTCC} \
    AS=${AS} AR=${AR} NM=${NM} \
    OBJCOPY=${OBJCOPY} OBJDUMP=${OBJDUMP} STRIP=${STRIP} \
    O=out CLANG_TRIPLE=${CLANG_TRIPLE} \
    CROSS_COMPILE=${CROSS_COMPILE} \
    LD=${LD} \
    oldconfig

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

# make O=out prepare

# make O=out modules SUBDIRS=drivers/misc/mediatek/connectivity
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
