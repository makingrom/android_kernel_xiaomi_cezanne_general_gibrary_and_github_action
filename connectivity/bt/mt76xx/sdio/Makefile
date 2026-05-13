###############################################################################
# Bluetooth character device driver
###############################################################################

ifeq ($(AUTOCONF_H),)
    $(error AUTOCONF_H is not defined)
endif

ccflags-y += -imacros $(AUTOCONF_H)
ccflags-y += -DCONFIG_MP_WAKEUP_SOURCE_SYSFS_STAT

# 编译文件定义
btmtksdio-objs += btmtk_sdio.o \
                   btmtk_main.o

# ===================== 自动切换：内置 / 模块 =====================
ifeq ($(CONFIG_MTK_COMBO_BT),y)
obj-y += btmtksdio.o
else ifeq ($(CONFIG_MTK_COMBO_BT),m)
obj-m += btmtksdio.o
endif###############################################################################
# Bluetooth character device driver

###############################################################################
# Necessary Check

ifeq ($(AUTOCONF_H),)
    $(error AUTOCONF_H is not defined)
endif

ccflags-y += -imacros $(AUTOCONF_H)
ccflags-y += -DCONFIG_MP_WAKEUP_SOURCE_SYSFS_STAT

MODULE_NAME := btmtksdio
obj-m += $(MODULE_NAME).o

#ccflags-y += -D CREATE_NODE_DYNAMIC=1

$(MODULE_NAME)-objs += btmtk_sdio.o \
                       btmtk_main.o
