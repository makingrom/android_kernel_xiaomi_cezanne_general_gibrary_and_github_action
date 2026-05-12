CONFIG_ENV=config.env

# 编译内核基本配置
# 内核源码地址
KERNEL_SOURCE=https://github.com/makingrom/android_kernel_xiaomi_cezanne_general_gibrary_and_github_action.git
# 内核源码分支
KERNEL_SOURCE_BRANCH=r
# 内核编译配置地址
KERNEL_CONFIG=cezanne_user_defconfig
# 安卓版本号（10/11/12/13/14）
ANDROID_VERSION=11
# 内核版本(4.4/4.14/4.19/5.4)
KERNEL_VERSION=4.14
# 缓存版本（修改后不用原缓存）
CACHE_VERSION=0.03
# 编译设备的硬件架构 ARM64(x86、x86_64、arm、arm64)
ARCH=arm64
# 是否使用build-kernel.bash
USE_BUILD_BASH=true
# build-kernel.bash构建脚本直链
BUILD_BASH_LINK=https://raw.githubusercontent.com/makingrom/android_kernel_xiaomi_cezanne_general_gibrary_and_github_action/build_kernel_bash/build.sh
# 是否使用 SETUP_KERNEL_CONFIG.bash
USE_SETUP_KERNEL_CONFIG=true
# SETUP_KERNEL_CONFIG 执行脚本直链
SETUP_KERNEL_CONFIG_LINK=https://raw.githubusercontent.com/makingrom/android_kernel_xiaomi_cezanne_general_gibrary_and_github_action/build_kernel_bash/setup_kernel_config.sh
# 是否 启用MTK内核专属模块
USE_MTK_KERNEL_MODULES=true
# MTK内核模块保存目录
MTK_KERNEL_MODULES_SOURCE_DIR=mtk-kernel-moudules-cezanne-r-oss
# MTK内核模块源
MTK_KERNEL_MODULES_SOURCE=https://github.com/makingrom/android_kernel_xiaomi_cezanne_general_gibrary_and_github_action.git
# MTK内核模块分支
MTK_KERNEL_MODULES_SOURCE_BRANCH=mtk-kernel-modules-cezanne-r-oss


# 配置编译源、编译工具
# 编译方案'A'clang+gcc编译 'B'clang编译
METHOD_OK=A

# 使用自定义的 GCC && CLANG 综合工具链USE_GCC_AND_CLANG
USE_GCC_AND_CLANG=false
# 工具链目录
GCC_AND_CLANG_DIR=proton-clang
# 工具链克隆源
GCC_AND_CLANG_SOURCE=https://github.com/makingrom/proton-clang.git
# 克隆源分支
GCC_AND_CLANG_BRANCH=master

# 是否「使用自定义 Clang」，改用下方配置的 AOSP 官方 Clang，空则不使用
USE_CUSTOM_CLANG=true
# 自定义 Clang 的仓库地址 / 分支（因 USE_CUSTOM_CLANG=false，这两个参数无效）
CUSTOM_CLANG_DIR=clang-r383902
CUSTOM_CLANG_SOURCE=https://github.com/makingrom/android_kernel_xiaomi_cezanne_general_gibrary_and_github_action.git
CUSTOM_CLANG_BRANCH=clang-r383902
# 强制指定 Clang 的「架构前缀」为 ARM64 Linux 标准（而非 Android 专属）
CUSTOM_CMDS:CLANG_TRIPLE=aarch64-linux-gnu-


## 编译器AOSP
# https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master-kernel-build-2022/clang-r450784e.tar.gz
# 分支main     android-gs-bluejay-5.10-android13      android-msm-bonito-4.9-android12-qpr1  android-msm-coral-4.14-android13  
# 3289846       3289846                                3289846                                 3289846
# r450784e      r416183b                               r383902                                 r383902
# r475365b      r450784d                               r399163b                                r399163b
# r487747c      r450784e                               r416183b                                r416183b
# r498229
# AOSP 官方 Clang 的分支（2022 年内核编译专用分支）
CLANG_BRANCH=master-kernel-build-2022
# AOSP 官方 Clang 的版本号（r450784e 是稳定版）
CLANG_VERSION=r450784e

# 启用 ARM64/ARM32 版本的 GCC 编译器
ENABLE_GCC_ARM64=true
ENABLE_GCC_ARM32=false
# 是否「自定义 ARM64 GCC」，用默认版本
USE_CUSTOM_GCC_64=true
CUSTOM_GCC_64_DIR=aarch64-linux-android-4.9
CUSTOM_GCC_64_SOURCE=https://github.com/makingrom/android_kernel_xiaomi_cezanne_general_gibrary_and_github_action.git
CUSTOM_GCC_64_BRANCH=aarch64-linux-android-4.9
# ARM64 GCC 的命令前缀（比如 aarch64-linux-android-gcc）
CUSTOM_GCC_64_BIN=aarch64-linux-android-
# 同理，控制 32 位 ARM GCC，因你是 ARM64 内核，这部分仅作备用
USE_CUSTOM_GCC_32=false
CUSTOM_GCC_32_DIR=aarch64-linux-android-4.9
CUSTOM_GCC_32_SOURCE=https://github.com/makingrom/android_kernel_xiaomi_cezanne_general_gibrary_and_github_action.git
CUSTOM_GCC_32_BRANCH=aarch64-linux-android-4.9
CUSTOM_GCC_32_BIN=arm-linux-androideabi-


# Kernel集成、生成AnyKernel3包
# 是否 KernelSU 集成
ENABLE_KERNELSU=false
# 指定要集成的 KernelSU 版本（v0.9.5 是稳定版）
KERNELSU_TAG=v0.9.5
# KernelSU 产物的大小 / 哈希校验值（可选）
KSU_EXPECTED_SIZE=
KSU_EXPECTED_HASH=
# 是否 使用自定义 AnyKernel3（内核打包工具）
USE_CUSTOM_ANYKERNEL3=false
CUSTOM_ANYKERNEL3_SOURCE=https://github.com/osm0sis/AnyKernel3
CUSTOM_ANYKERNEL3_BRANCH=master


# 编译器功能、模块配置
# 是否 需要切换python3(true)/python2(false)/默认(空)
SWITCH_PYTHON=false
# 编译前 是否 删除系统无用的内核包
REMOVE_UNUSED_PACKAGES=false
# 是否 开启Ccache 缓存
ENABLE_CCACHE=false


# 内核编译链接器，默认可能用 GCC 的 ld，这里强制改用 LLVM 的 ld.lld
EXTRA_CMDS:"LD=ld.lld"
# 是否 开启LLVM=1 LLVM_IAS=1参数配置 开启(true)/自定义(false)/默认(空)
LLVM_CONFIG=
# 自定义LLVM工具链参数配置(例如" LLVM=1 LLVM_IAS=1",开头要带空格)
LLVM_PARAMS=
# LLVM_PARAMS="LLVM=1 LLVM_IAS=1 AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip"


# 编译生成文件配置
# 低端机填Image.gz-dtb，高端机可以选择Image.gz，Image，Image*
KERNEL_IMAGE_NAME=Image.gz-dtb
# 是否 上传MTK驱动模块.ko文件
MTK_KERNEL_MODULES_UPLOAD=false
# 是否 需要dtbo，一般不需要，false即可
NEED_DTBO=false
# 是否 编译完整的 boot.img
BUILD_BOOT_IMG=false
# 原始 boot.img 的下载地址（用于拼接内核镜像生成新 boot.img）
SOURCE_BOOT_IMAGE=https://raw.githubusercontent.com/makingrom/LXC-DOCKER-KernelSU_Action/refs/heads/main/boot/boot.img


# 定义所有需要导出的变量列表
CONFIG_LIST=(
	KERNEL_SOURCE
	KERNEL_SOURCE_BRANCH
	KERNEL_CONFIG
	ANDROID_VERSION
	KERNEL_VERSION
	CACHE_VERSION
	ARCH
	USE_BUILD_BASH
	BUILD_BASH_LINK
	USE_SETUP_KERNEL_CONFIG
	SETUP_KERNEL_CONFIG_LINK
	USE_MTK_KERNEL_MODULES
    MTK_KERNEL_MODULES_SOURCE_DIR
    MTK_KERNEL_MODULES_SOURCE
    MTK_KERNEL_MODULES_SOURCE_BRANCH
    METHOD_OK
    USE_GCC_AND_CLANG
    GCC_AND_CLANG_DIR
    GCC_AND_CLANG_SOURCE
    GCC_AND_CLANG_BRANCH
    KERNEL_IMAGE_NAME
    ADD_LOCALVERSION_TO_FILENAME
    USE_CUSTOM_CLANG
    CUSTOM_CLANG_DIR
    CUSTOM_CLANG_SOURCE
    CUSTOM_CLANG_BRANCH
    CUSTOM_CMDS
    CLANG_BRANCH
    CLANG_VERSION
    ENABLE_GCC_ARM64
    ENABLE_GCC_ARM32
    USE_CUSTOM_GCC_64
    CUSTOM_GCC_64_DIR
    CUSTOM_GCC_64_SOURCE
    CUSTOM_GCC_64_BRANCH
    CUSTOM_GCC_64_BIN
    USE_CUSTOM_GCC_32
    CUSTOM_GCC_32_DIR
    CUSTOM_GCC_32_SOURCE
    CUSTOM_GCC_32_BRANCH
    CUSTOM_GCC_32_BIN
    ENABLE_KERNELSU
    KERNELSU_TAG
    KSU_EXPECTED_SIZE
    KSU_EXPECTED_HASH
    USE_CUSTOM_ANYKERNEL3
    CUSTOM_ANYKERNEL3_SOURCE
    CUSTOM_ANYKERNEL3_BRANCH
    SWITCH_PYTHON
    REMOVE_UNUSED_PACKAGES
    ENABLE_CCACHE
    EXTRA_CMDS
    LLVM_CONFIG
    LLVM_PARAMS
    KERNEL_IMAGE_NAME
    MTK_KERNEL_MODULES_UPLOAD
    NEED_DTBO
    BUILD_BOOT_IMG
    SOURCE_BOOT_IMAGE
    
    USE_DISABLE_LTO
    DISABLE_CC_WERROR
    ADD_KPROBES_CONFIG
    ADD_OVERLAYFS_CONFIG
    APPLY_KSU_PATCH
    USE_ENABLE_KVM
    LXC_DOCKER
    LXC_PATCH
    ANDROID_PARANOID_NETWORK_OFF

    USE_VERSION_PARAMS_CONFIG
    VERSION_PARAMS
    DISABLE_STACK_PROTECTOR
    ANDROID_VER_INT
    KERNEL_VER_MAJOR
    KERNEL_VER_MINOR
)

# 自动写入 GITHUB_ENV（所有变量全局生效）
for CONFIG in "${CONFIG_LIST[@]}"; do
    VALUE="${!CONFIG}"
    echo "${CONFIG}=${VALUE}"
    echo "${CONFIG}=${VALUE}" >> $GITHUB_ENV
    echo "===================================================================="
done

echo "✅ 所有环境变量已从 env.sh 加载完成！"
