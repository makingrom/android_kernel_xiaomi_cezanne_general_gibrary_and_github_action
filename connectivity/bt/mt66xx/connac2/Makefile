MTK_PLATFORM := $(subst ",,$(CONFIG_MTK_PLATFORM))
###############################################################################
# Bluetooth character device driver
###############################################################################

ifneq ($(KERNEL_OUT),)
    ccflags-y += -imacros $(KERNEL_OUT)/include/generated/autoconf.h
endif

$(warning connac20 bt driver: _MTK_BT_CHIP = $(_MTK_BT_CHIP))
CONNAC20_CHIPID=$(subst MTK_CONSYS_MT,,$(_MTK_BT_CHIP))
ccflags-y += -D CONNAC20_CHIPID=$(CONNAC20_CHIPID)
$(warning connac20 bt driver: CONNAC20_CHIPID = $(CONNAC20_CHIPID))

# only for sw-ready-go
ifeq ($(_MTK_BT_CHIP), MTK_CONSYS_MT6893)
ifneq ($(filter yes, $(_MTK_PLAT_MT6885_EMULATION)),)
    $(warning connac20 bt driver: 6885 emulation is set!)
    ccflags-y += -D CONNAC20_CHIPID=6885
endif
endif

ifndef TOP
    TOP := $(srctree)/..
endif

USE_DEVICE_NODE := y
#CUSTOMER_FW_UPDATE := y

ccflags-y += -DCHIP_IF_BTIF

# Customized feature, load 1b fw bin
#ccflags-y += -D BT_CUS_FEATURE

# Force build fail on modpost warning
KBUILD_MODPOST_FAIL_ON_WARNINGS := y
###############################################################################

# ---------------------------------------------------
# Compile Options
# ---------------------------------------------------
ccflags-y += -D CREATE_NODE_DYNAMIC=1

ifeq ($(CUSTOMER_FW_UPDATE), y)
ccflags-y += -D CUSTOMER_FW_UPDATE=1
else
ccflags-y += -D CUSTOMER_FW_UPDATE=0
endif

ifneq ($(CFG_BT_PM_QOS_CONTROL),)
    $(warning set PM_QOS_CONTROL=1)
    ccflags-y += -D PM_QOS_CONTROL=1
else
    ccflags-y += -D PM_QOS_CONTROL=0
endif

# ---------------------------------------------------
# Include Path
# ---------------------------------------------------
CONN_INFRA_SRC := $(TOP)/vendor/mediatek/kernel_modules/connectivity/conninfra
WMT_SRC := $(TOP)/vendor/mediatek/kernel_modules/connectivity/common
BTIF_SRC := $(srctree)/drivers/misc/mediatek/btif
ccflags-y += -I$(srctree)/drivers/misc/mediatek/connectivity/common
ccflags-y += -I$(CONN_INFRA_SRC)/include
ccflags-y += -I$(CONN_INFRA_SRC)/debug_utility/include
ccflags-y += -I$(CONN_INFRA_SRC)/debug_utility/
ifneq ($(CONFIG_MTK_CONNSYS_DEDICATED_LOG_PATH),)
ccflags-y += -I$(WMT_SRC)/debug_utility
endif
ccflags-y += -I$(BTIF_SRC)/common/inc

ccflags-y += -I$(src)/core/include
ccflags-y += -I$(src)/connsys/connac_2_0

ifeq ($(USE_DEVICE_NODE), y)
ccflags-y += -DUSE_DEVICE_NODE=1
else
ccflags-y += -DUSE_DEVICE_NODE=0
endif

# ---------------------------------------------------
# Objects List
# ---------------------------------------------------
CORE_OBJS := btmtk_main.o btmtk_dbg.o btmtk_irq.o

ifeq ($(USE_DEVICE_NODE), y)
CORE_OBJS += btmtk_char_dev.o btmtk_queue.o
endif

CHIP_OBJS := btmtk_mt66xx.o
HIF_OBJS := btmtk_btif_main.o btmtk_fw_log.o

# 自动适配 内置y / 模块m
bt_drv-objs := $(CORE_OBJS) $(HIF_OBJS) $(CHIP_OBJS)

ifeq ($(CONFIG_MTK_COMBO_BT),y)
obj-y += bt_drv.o
else ifeq ($(CONFIG_MTK_COMBO_BT),m)
obj-m += bt_drv.o
endif
