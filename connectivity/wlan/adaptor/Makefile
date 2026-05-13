###############################################################################
# Necessary Check

ifneq ($(KERNEL_OUT),)
    ccflags-y += -imacros $(KERNEL_OUT)/include/generated/autoconf.h
endif

ifndef TOP
    TOP := $(srctree)/..
endif

# Force build fail on modpost warning
KBUILD_MODPOST_FAIL_ON_WARNINGS := y

ccflags-y += \
    -I$(srctree)/drivers/misc/mediatek/include/mt-plat \
    -I$(TOP)/vendor/mediatek/kernel_modules/connectivity/common/common_main/include \
    -I$(TOP)/vendor/mediatek/kernel_modules/connectivity/common/common_main/linux/include

ifeq ($(ADAPTOR_OPTS),CONNAC2X2_SOC3_0)
ccflags-y += -I$(TOP)/vendor/mediatek/kernel_modules/connectivity/conninfra/include
ccflags-y += -I$(TOP)/vendor/mediatek/kernel_modules/connectivity/conninfra/debug_utility
ccflags-y += -I$(TOP)/vendor/mediatek/kernel_modules/connectivity/conninfra/debug_utility/include
ccflags-y += -I$(TOP)/vendor/mediatek/kernel_modules/connectivity/conninfra/debug_utility/connsyslog
ccflags-y += -I$(TOP)/vendor/mediatek/kernel_modules/connectivity/conninfra/debug_utility/coredump
endif

ifneq ($(CONFIG_MTK_CONNSYS_DEDICATED_LOG_PATH),)
ccflags-y += -DCONFIG_MTK_CONNSYS_DEDICATED_LOG_PATH
ccflags-y += -I$(TOP)/vendor/mediatek/kernel_modules/connectivity/common/debug_utility
endif

ifeq ($(CONFIG_MTK_CONN_LTE_IDC_SUPPORT),y)
    ccflags-y += -DWMT_IDC_SUPPORT=1
else
    ccflags-y += -DWMT_IDC_SUPPORT=0
endif

ifeq ($(ADAPTOR_OPTS),CONNAC2X2_SOC3_0)
ccflags-y += -DCFG_ANDORID_CONNINFRA_SUPPORT=1
ccflags-y += -DCFG_ANDORID_CONNINFRA_COREDUMP_SUPPORT=1
else
ccflags-y += -DCFG_ANDORID_CONNINFRA_SUPPORT=0
ccflags-y += -DCFG_ANDORID_CONNINFRA_COREDUMP_SUPPORT=0
endif

ccflags-y += -D MTK_WCN_WMT_STP_EXP_SYMBOL_ABSTRACT

ccflags-y += -D CREATE_NODE_DYNAMIC=1

# ============================================================================
# 🔥 自动切换：内置 / 模块（适配你 CONFIG_MTK_COMBO_WLAN）
# ============================================================================
wmt_chrdev_wifi-objs += wmt_cdev_wifi.o

ifneq ($(CONFIG_MTK_CONNSYS_DEDICATED_LOG_PATH),)
wmt_chrdev_wifi-objs += fw_log_wifi.o
endif

ifeq ($(ADAPTOR_OPTS),CONNAC2X2_SOC3_0)
wmt_chrdev_wifi-objs += wifi_pwr_on.o
endif

# 自动根据 WLAN 配置切换
ifeq ($(CONFIG_MTK_COMBO_WLAN),y)
obj-y += wmt_chrdev_wifi.o
else ifeq ($(CONFIG_MTK_COMBO_WLAN),m)
obj-m += wmt_chrdev_wifi.o
endif
