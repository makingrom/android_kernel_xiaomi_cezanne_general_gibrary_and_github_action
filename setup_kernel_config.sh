#!/bin/bash
set -e

# 自动从环境变量读取所有配置（和 GitHub Action 环境完全兼容）
ARCH="${ARCH}"
KERNEL_CONFIG="${KERNEL_CONFIG}"
ANDROID_VERSION="${ANDROID_VERSION}"
KERNEL_VERSION="${KERNEL_VERSION}"

# 关闭报错的联发科视频编解码（VCU/VCODEC）
sed -i '/CONFIG_MTK_VCODEC/d' arch/${ARCH}/configs/${KERNEL_CONFIG}
sed -i '/CONFIG_MTK_VCU/d' arch/${ARCH}/configs/${KERNEL_CONFIG}
sed -i '/CONFIG_VIDEO_MEDIATEK_VCU/d' arch/${ARCH}/configs/${KERNEL_CONFIG}

echo "CONFIG_MTK_VCODEC=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
echo "CONFIG_MTK_VCU=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
echo "CONFIG_VIDEO_MEDIATEK_VCU=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}

# ===================== KSU 配置 =====================
if [ "${APPLY_KSU_PATCH}" = "true" ]; then
    echo "当前目录：$(pwd)"
    wget https://raw.githubusercontent.com/Frostleaft07/KernelSU-Patch/refs/heads/main/hooks-k4.19/official_hook_4.19.patch
    patch -p1 < official_hook_4.19.patch

    if grep -q "CONFIG_KSU" arch/${ARCH}/configs/${KERNEL_CONFIG}; then
        sed -i 's/# CONFIG_KSU is not set/CONFIG_KSU=y/g' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
        sed -i 's/CONFIG_KSU=n/CONFIG_KSU=y/g' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    else
        echo "CONFIG_KSU=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG} || echo "⚠️ 开启 CONFIG_KSU 失败"
        echo "CONFIG_KPM=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG} || echo "⚠️ 开启 CONFIG_KPM 失败"
    fi
    echo "✅ 已应用 KSU 补丁并开启 CONFIG_KSU"
fi

if [ "${APPLY_KSU_PATCH}" = "false" ]; then
    echo "⚠️ 配置目录 $(pwd)"
    if grep -q "CONFIG_KSU" arch/${ARCH}/configs/${KERNEL_CONFIG}; then
        sed -i 's/CONFIG_KSU=y/CONFIG_KSU=n/g' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
        sed -i 's/# CONFIG_KSU is not set/CONFIG_KSU=n/g' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    else
        echo "CONFIG_KSU=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG} || echo "⚠️ 关闭 CONFIG_KSU 失败"
        echo "CONFIG_KPM=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG} || echo "⚠️ 关闭 CONFIG_KPM 失败"
    fi
    echo "✅ 已关闭 CONFIG_KSU"
fi

if [ "${APPLY_KSU_PATCH}" = "" ]; then
    echo "CONFIG_KSU=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG} || echo "⚠️ 开启 CONFIG_KSU 失败"
    echo "CONFIG_KPM=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG} || echo "⚠️ 开启 CONFIG_KPM 失败"
    echo "CONFIG_SUPERCALL=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG} || echo "⚠️ 开启 CONFIG_SUPERCALL 失败"
    echo "CONFIG_KSU_ALLOWLIST=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG} || echo "⚠️ 开启 CONFIG_KSU_ALLOWLIST 失败"
    echo "✅ 保持默认 KSU 配置"
fi

# ===================== KPROBES =====================
if [ "${ADD_KPROBES_CONFIG}" = "true" ]; then
    sed -i '/CONFIG_MODULES/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i '/CONFIG_KPROBES/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i '/CONFIG_HAVE_KPROBES/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i '/CONFIG_KPROBE_EVENTS/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null

    echo "CONFIG_MODULES=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_KPROBES=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_HAVE_KPROBES=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_KPROBE_EVENTS=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 已启用 kprobes 相关配置"
fi

if [ "${ADD_KPROBES_CONFIG}" = "false" ]; then
    sed -i '/CONFIG_MODULES/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i '/CONFIG_KPROBES/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i '/CONFIG_HAVE_KPROBES/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i '/CONFIG_KPROBE_EVENTS/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null

    echo "CONFIG_MODULES=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_KPROBES=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_HAVE_KPROBES=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_KPROBE_EVENTS=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 已关闭 kprobes 相关配置"
fi

if [ "${ADD_KPROBES_CONFIG}" = "" ]; then
    echo "✅ 保持默认 kprobes 配置"
fi

# ===================== OverlayFS =====================
if [ "${ADD_OVERLAYFS_CONFIG}" = "true" ]; then
    sed -i '/CONFIG_OVERLAY_FS/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    echo "CONFIG_OVERLAY_FS=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 已启用 OverlayFS"
fi

if [ "${ADD_OVERLAYFS_CONFIG}" = "false" ]; then
    sed -i '/CONFIG_OVERLAY_FS/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    echo "CONFIG_OVERLAY_FS=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 已禁用 OverlayFS"
fi

if [ "${ADD_OVERLAYFS_CONFIG}" = "" ]; then
    echo "✅ 保持默认 OverlayFS 配置"
fi

# ===================== LTO =====================
if [ "${USE_DISABLE_LTO}" = "true" ]; then
    sed -i 's/CONFIG_LTO=n/CONFIG_LTO=y/' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i 's/CONFIG_LTO_CLANG=n/CONFIG_LTO_CLANG=y/' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i 's/CONFIG_THINLTO=n/CONFIG_THINLTO=y/' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    echo "CONFIG_LTO_NONE=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 已启用 LTO 优化"
fi

if [ "${USE_DISABLE_LTO}" = "false" ]; then
    sed -i 's/CONFIG_LTO=y/CONFIG_LTO=n/' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i 's/CONFIG_LTO_CLANG=y/CONFIG_LTO_CLANG=n/' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i 's/CONFIG_THINLTO=y/CONFIG_THINLTO=n/' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    echo "CONFIG_LTO_NONE=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 已禁用 LTO 优化"
fi

if [ "${USE_DISABLE_LTO}" = "" ]; then
    echo "✅ 保持默认 LTO 配置"
fi

# ===================== CC_WERROR =====================
if [ "${DISABLE_CC_WERROR}" = "true" ]; then
    sed -i '/CONFIG_CC_WERROR/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    echo "CONFIG_CC_WERROR=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 已开启内核错误警告"
fi

if [ "${DISABLE_CC_WERROR}" = "false" ]; then
    sed -i '/CONFIG_CC_WERROR/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    echo "CONFIG_CC_WERROR=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 已关闭内核错误警告"
fi

if [ "${DISABLE_CC_WERROR}" = "" ]; then
    echo "✅ 保持默认错误警告配置"
fi

# ===================== LLVM_CONFIG =====================
if [ "${LLVM_CONFIG}" = "true" ]; then
    LLVM_PARAMS=" LLVM=1 LLVM_IAS=1"
    echo "LLVM_PARAMS=$LLVM_PARAMS" >> $GITHUB_ENV 2>/dev/null
    echo "✅ 编译使用 LLVM_CONFIG 参数"
elif [ "${LLVM_CONFIG}" = "false" ]; then
    echo "LLVM_PARAMS=$LLVM_PARAMS" >> $GITHUB_ENV 2>/dev/null
    echo "✅ 编译使用 LLVM_CONFIG 参数"
fi

# ===================== VERSION PARAMS =====================
if [ "${USE_VERSION_PARAMS_CONFIG}" = "false" ]; then
    ANDROID_VER_INT=$(echo $ANDROID_VERSION | awk '{print int($0)}')

    if [ "$ANDROID_VER_INT" -eq 10 ] || [ "$ANDROID_VER_INT" -eq 11 ]; then
        VERSION_PARAMS="KBUILD_CFLAGS+=-Wno-error=deprecated-declarations KBUILD_CFLAGS+=-Wno-error=unused-const-variable"
    fi

    if [ $ANDROID_VER_INT -ge 12 ]; then
        VERSION_PARAMS="KBUILD_CFLAGS+=-Wno-error=unused-but-set-variable KBUILD_CFLAGS+=-Wno-error=incompatible-pointer-types"
    fi

    KERNEL_VER_MAJOR=$(echo $KERNEL_VERSION | cut -d. -f1 | awk '{print int($0)}')
    KERNEL_VER_MINOR=$(echo $KERNEL_VERSION | cut -d. -f2 | awk '{print int($0)}')

    if [ $KERNEL_VER_MAJOR -ge 5 ] || [ $KERNEL_VER_MINOR -ge 10 ]; then
        if [ -n "$VERSION_PARAMS" ]; then
            VERSION_PARAMS="$VERSION_PARAMS CONFIG_LTO_CLANG=y"
        else
            VERSION_PARAMS="CONFIG_LTO_CLANG=y"
        fi
    fi

    echo "VERSION_PARAMS=$VERSION_PARAMS" >> $GITHUB_ENV 2>/dev/null
    echo "✅ VERSION_PARAMS 已赋值..."
fi

# ===================== KVM =====================
if [ "${USE_ENABLE_KVM}" = "true" ]; then
    echo "CONFIG_KVM=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_KVM_ARM64=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_VIRTUALIZATION=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_VHOST_NET=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ KVM 已开启"
fi

if [ "${USE_ENABLE_KVM}" = "false" ]; then
    sed -i 's/CONFIG_KVM=y/CONFIG_KVM=n/g' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i 's/CONFIG_KVM_ARM64=y/CONFIG_KVM_ARM64=n/g' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    echo "CONFIG_KVM=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_KVM_ARM64=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_VIRTUALIZATION=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_VHOST_NET=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_VHOST_CROSS_ENDIAN_LEGACY=n" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ KVM 已关闭"
fi

if [ "${USE_ENABLE_KVM}" = "" ]; then
    echo "✅ 保持内核默认 KVM 状态"
fi

# ===================== STACK PROTECTOR =====================
if [ "${DISABLE_STACK_PROTECTOR}" = "true" ]; then
    sed -i 's/# CONFIG_CC_STACKPROTECTOR_STRONG is not set/CONFIG_CC_STACKPROTECTOR_STRONG=y/g' arch/${ARCH}/configs/${KERNEL_CONFIG}
    sed -i 's/# CONFIG_CC_STACKPROTECTOR is not set/CONFIG_CC_STACKPROTECTOR=y/g' arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 栈保护已启用"
fi

if [ "${DISABLE_STACK_PROTECTOR}" = "false" ]; then
    sed -i 's/CONFIG_CC_STACKPROTECTOR_STRONG=y/# CONFIG_CC_STACKPROTECTOR_STRONG is not set/g' arch/${ARCH}/configs/${KERNEL_CONFIG}
    sed -i 's/CONFIG_CC_STACKPROTECTOR=y/# CONFIG_CC_STACKPROTECTOR is not set/g' arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ 栈保护已禁用"
fi

if [ "${DISABLE_STACK_PROTECTOR}" = "" ]; then
    echo "✅ 保留默认栈保护配置"
fi

# ===================== LXC DOCKER =====================
if [ "${LXC_DOCKER}" = "true" ]; then
    if [ ! -f LXC-DOCKER-OPEN-CONFIG.sh ]; then
        wget https://raw.githubusercontent.com/makingrom/LXC-DOCKER-KernelSU_Action/refs/heads/main/Lxc_Docker/LXC-DOCKER-OPEN-CONFIG.sh
        chmod 777 LXC-DOCKER-OPEN-CONFIG.sh
    fi
    ./LXC-DOCKER-OPEN-CONFIG.sh arch/${ARCH}/configs/${KERNEL_CONFIG} -w
    echo "✅ LXC 已启用"
else
    echo "✅ LXC 保持默认"
fi

if [ "${LXC_PATCH}" = "true" ]; then
    wget https://raw.githubusercontent.com/makingrom/LXC-DOCKER-KernelSU_Action/refs/heads/main/Lxc_Docker/runcpatch.sh
    chmod a+x runcpatch.sh

    if [ -f kernel/cgroup.c ]; then
        ./runcpatch.sh kernel/cgroup.c
    fi
    if [ -f kernel/cgroup/cgroup.c ]; then
        ./runcpatch.sh kernel/cgroup/cgroup.c
    fi
    if [ -f net/netfilter/xt_qtaguid.c ]; then
        wget https://raw.githubusercontent.com/makingrom/LXC-DOCKER-KernelSU_Action/refs/heads/main/Lxc_Docker/lxc.patch
        patch -p0 < lxc.patch
    fi
    echo "✅ LXC补丁执行完毕"
fi

# ===================== ANDROID PARANOID NETWORK =====================
if [ "${ANDROID_PARANOID_NETWORK_OFF}" = "true" ]; then
    sed -i '/CONFIG_ANDROID_PARANOID_NETWORK/d' arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "# CONFIG_ANDROID_PARANOID_NETWORK is not set" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ ANDROID_PARANOID_NETWORK 已关闭"
fi

if [ "${ANDROID_PARANOID_NETWORK_OFF}" = "false" ]; then
    sed -i '/CONFIG_ANDROID_PARANOID_NETWORK/d' arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_ANDROID_PARANOID_NETWORK=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "✅ ANDROID_PARANOID_NETWORK 已开启"
fi

# ===================== 处理器平台选择（骁龙/联发科）=====================
if [ "${Device_Processor_Selection}" = "true" ]; then
    echo "✅ 启用 【骁龙平台】 专属配置"
    sed -i 's/CONFIG_MTK_.*=y//g' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i '/CONFIG_MTK_/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null

    echo "CONFIG_QCOM_SCM=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_QCOM_CLK=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_QCOM_SPMI=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_MSM_SLEEP=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_QCOM_RTP=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_QCOM_SPSS=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_QCOM_CLK_V2=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
fi

if [ "${Device_Processor_Selection}" = "false" ]; then
    echo "✅ 启用 【联发科平台】 专属配置"
    sed -i 's/CONFIG_QCOM_.*=y//g' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
    sed -i '/CONFIG_QCOM_/d' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null

    echo "CONFIG_MTK_EMI=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_MTK_PMIC=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_MTK_CLKMGR=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_MTK_COMBO=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_MTK_NFC_SUPPORT=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_MTK_DRV=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_MTK_BOOT=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_MTK_FB=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    echo "CONFIG_MTK_GPU=y" >> arch/${ARCH}/configs/${KERNEL_CONFIG}
    sed -i 's/CONFIG_MTK_NFC_CLKBUF_ENABLE=y/CONFIG_MTK_NFC_CLKBUF_ENABLE=n/g' arch/${ARCH}/configs/${KERNEL_CONFIG} 2>/dev/null
fi

echo -e "\n🎉 内核配置脚本执行完成！"
