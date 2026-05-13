MTK_PLATFORM := $(subst ",,$(CONFIG_MTK_PLATFORM))

###############################################################################
# Bluetooth character device driver (Auto: built-in / module)
###############################################################################

ifndef TOP
    TOP := $(srctree)/..
endif

ifneq ($(KERNEL_OUT),)
    ccflags-y += -imacros $(KERNEL_OUT)/include/generated/autoconf.h
endif

ifeq ($(CFG_BT_PM_QOS_CONTROL),)
    ccflags-y += -D PM_QOS_CONTROL=0
else
    ccflags-y += -D PM_QOS_CONTROL=1
endif

###############################################################################
# WMT dependent Macro and header
###############################################################################
ccflags-y += -D MTK_WCN_WMT_STP_EXP_SYMBOL_ABSTRACT
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat/$(MTK_PLATFORM)/include

ifeq ($(CONFIG_MTK_CONN_LTE_IDC_SUPPORT),y)
    ccflags-y += -D WMT_IDC_SUPPORT=1
else
    ccflags-y += -D WMT_IDC_SUPPORT=0
endif

###############################################################################
# BT driver header
###############################################################################
WMT_SRC_FOLDER := $(TOP)/vendor/mediatek/kernel_modules/connectivity/common
ccflags-y += -I$(WMT_SRC_FOLDER)/common_main/include
ccflags-y += -I$(WMT_SRC_FOLDER)/common_main/linux/include

ifeq ($(CONFIG_MTK_CONNSYS_DEDICATED_LOG_PATH),y)
ccflags-y += -I$(WMT_SRC_FOLDER)/debug_utility
endif

ccflags-y += -D CREATE_NODE_DYNAMIC=1

###############################################################################
# 🔥 智能切换：内置 / 模块
###############################################################################

# 1. 定义对象文件
bt_drv-objs += stp_chrdev_bt.o
bt_drv-objs += dbg_bt.o

ifeq ($(CONFIG_MTK_CONNSYS_DEDICATED_LOG_PATH),y)
bt_drv-objs += fw_log_bt.o
endif

# 2. 根据 CONFIG 自动选择
ifeq ($(CONFIG_MTK_COMBO_BT),y)
# 内置进内核
obj-y += bt_drv.o
else ifeq ($(CONFIG_MTK_COMBO_BT),m)
# 编译为 .ko 模块
obj-m += bt_drv.o
endifMTK_PLATFORM := $(subst ",,$(CONFIG_MTK_PLATFORM))
###############################################################################
# Bluetooth character device driver

###############################################################################
# Necessary Check

ifneq ($(KERNEL_OUT),)
    ccflags-y += -imacros $(KERNEL_OUT)/include/generated/autoconf.h
endif

ifndef TOP
    TOP := $(srctree)/..
endif

ifneq ($(CFG_BT_PM_QOS_CONTROL),)
    $(warning set PM_QOS_CONTROL=1)
    ccflags-y += -D PM_QOS_CONTROL=1
else
    ccflags-y += -D PM_QOS_CONTROL=0
endif

# Force build fail on modpost warning
KBUILD_MODPOST_FAIL_ON_WARNINGS := y
###############################################################################
# To add WMT dependent Macro and header file, will be removed later

ccflags-y += -D MTK_WCN_WMT_STP_EXP_SYMBOL_ABSTRACT
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat/$(MTK_PLATFORM)/include

ifeq ($(CONFIG_MTK_CONN_LTE_IDC_SUPPORT),y)
    ccflags-y += -D WMT_IDC_SUPPORT=1
else
    ccflags-y += -D WMT_IDC_SUPPORT=0
endif

###############################################################################
# To include BT driver dependent header file

WMT_SRC_FOLDER := $(TOP)/vendor/mediatek/kernel_modules/connectivity/common
ccflags-y += -I$(WMT_SRC_FOLDER)/common_main/include
ccflags-y += -I$(WMT_SRC_FOLDER)/common_main/linux/include
ifneq ($(CONFIG_MTK_CONNSYS_DEDICATED_LOG_PATH),)
ccflags-y += -I$(WMT_SRC_FOLDER)/debug_utility
endif

###############################################################################

MODULE_NAME := bt_drv
obj-y += $(MODULE_NAME).o

ccflags-y += -D CREATE_NODE_DYNAMIC=1

$(MODULE_NAME)-objs += stp_chrdev_bt.o
$(MODULE_NAME)-objs += dbg_bt.o
ifneq ($(CONFIG_MTK_CONNSYS_DEDICATED_LOG_PATH),)
$(MODULE_NAME)-objs += fw_log_bt.o
endif
