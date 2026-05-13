MTK_PLATFORM := $(subst ",,$(CONFIG_MTK_PLATFORM))
###############################################################################
# Necessary Check

ifneq ($(KERNEL_OUT),)
    ccflags-y += -imacros $(KERNEL_OUT)/include/generated/autoconf.h
endif

# Force build fail on modpost warning
KBUILD_MODPOST_FAIL_ON_WARNINGS := y
###############################################################################

CONNSYS_PLATFORM := $(TARGET_BOARD_PLATFORM_CONNINFRA)

ifeq ($(CONNSYS_PLATFORM),)
$(info $$CONFIG_MTK_COMBO_CHIP is [${CONFIG_MTK_COMBO_CHIP}])
ifneq ($(CONFIG_MTK_COMBO_CHIP),)
CONNINFRA_PLATFORM_ID := $(patsubst CONSYS_%,mt%,$(subst ",,$(CONFIG_MTK_COMBO_CHIP)))
$(info CONNINFRA_PLATFORM_ID is [${CONNINFRA_PLATFORM_ID}])
CONNSYS_PLATFORM := $(CONNINFRA_PLATFORM_ID)
else
CONNSYS_PLATFORM := $(MTK_PLATFORM)
endif
endif
$(info $$CONNSYS_PLATFORM is [${CONNSYS_PLATFORM}])

ifeq ($(CONFIG_ARM64), y)
    ccflags-y += -D CONFIG_MTK_WCN_ARM64
endif

ccflags-y += -D CONNINFRA_PLAT_ALPS=1
ccflags-y += -D MTK_WCN_WMT_STP_EXP_SYMBOL_ABSTRACT
ccflags-y += -D MTK_CONNINFRA_CLOCK_BUFFER_API_AVAILABLE=1

ccflags-y += -I$(srctree)/drivers/misc/mediatek/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat/$(CONNSYS_PLATFORM)/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat/$(CONNSYS_PLATFORM)/include/mach
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat
ccflags-y += -I$(srctree)/drivers/misc/mediatek/base/power/$(CONNSYS_PLATFORM)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/base/power/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/base/power/include/clkbuf_v1
ccflags-y += -I$(srctree)/drivers/misc/mediatek/base/power/include/clkbuf_v1/$(CONNSYS_PLATFORM)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/eccci
ccflags-y += -I$(srctree)/drivers/misc/mediatek/eccci/$(CONNSYS_PLATFORM)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/eemcs
ccflags-y += -I$(srctree)/drivers/misc/mediatek/mach/$(CONNSYS_PLATFORM)/include/mach
ccflags-y += -I$(srctree)/drivers/misc/mediatek/emi/submodule
ccflags-y += -I$(srctree)/drivers/misc/mediatek/emi/$(CONNSYS_PLATFORM)
ccflags-y += -I$(srctree)/drivers/mmc/core
ccflags-y += -I$(srctree)/drivers/misc/mediatek/connectivity/common
ccflags-y += -I$(srctree)/drivers/misc/mediatek/pmic/include/

ccflags-y += -Werror
ccflags-y += -Wno-error=format
ccflags-y += -Wno-error=format-extra-args

###############################################################################
# 🔥 自动切换：内置 / 模块
###############################################################################
conninfra-objs += base/ring.o
conninfra-objs += base/osal.o
conninfra-objs += base/msg_thread.o
conninfra-objs += core/conninfra_core.o
conninfra-objs += src/conninfra_dev.o
conninfra-objs += src/conninfra.o
conninfra-objs += conf/conninfra_conf.o
conninfra-objs += platform/consys_hw.o
conninfra-objs += platform/clock_mng.o
conninfra-objs += platform/pmic_mng.o
conninfra-objs += platform/emi_mng.o
conninfra-objs += platform/consys_reg_mng.o
conninfra-objs += debug_utility/conninfra_dbg.o

conninfra-objs += platform/$(CONNSYS_PLATFORM)/$(CONNSYS_PLATFORM).o
conninfra-objs += platform/$(CONNSYS_PLATFORM)/$(CONNSYS_PLATFORM)_pmic.o
conninfra-objs += platform/$(CONNSYS_PLATFORM)/$(CONNSYS_PLATFORM)_emi.o
conninfra-objs += platform/$(CONNSYS_PLATFORM)/$(CONNSYS_PLATFORM)_consys_reg.o
conninfra-objs += platform/$(CONNSYS_PLATFORM)/$(CONNSYS_PLATFORM)_pos.o

conninfra-objs += debug_utility/connsyslog/ring_emi.o
conninfra-objs += debug_utility/connsyslog/connsyslog.o
conninfra-objs += debug_utility/connsyslog/platform/$(CONNSYS_PLATFORM)/$(CONNSYS_PLATFORM).o
conninfra-objs += debug_utility/coredump/connsys_coredump.o
conninfra-objs += debug_utility/coredump/conndump_netlink.o
conninfra-objs += debug_utility/coredump/platform/$(CONNSYS_PLATFORM)/$(CONNSYS_PLATFORM).o

conninfra-objs += drv_init/bluetooth_drv_init.o
conninfra-objs += drv_init/conn_drv_init.o
conninfra-objs += drv_init/fm_drv_init.o
conninfra-objs += drv_init/gps_drv_init.o
conninfra-objs += drv_init/wlan_drv_init.o

ifneq ($(TARGET_BUILD_VARIANT), user)
ccflags-y += -D CFG_CONNINFRA_UT_SUPPORT
ccflags-y += -I$(src)/test/include
conninfra-objs += test/conninfra_core_test.o
conninfra-objs += test/conf_test.o
conninfra-objs += test/cal_test.o
conninfra-objs += test/msg_evt_test.o
conninfra-objs += test/chip_rst_test.o
conninfra-objs += test/conninfra_test.o
conninfra-objs += test/mailbox_test.o
conninfra-objs += test/connsyslog_test.o
conninfra-objs += test/dump_test.o
endif

# -----------------------------------------------------------------------------
# 自动根据 CONFIG_MTK_COMBO_WLAN 切换
# -----------------------------------------------------------------------------
ifeq ($(CONFIG_MTK_COMBO_WLAN),y)
obj-y += conninfra.o
else ifeq ($(CONFIG_MTK_COMBO_WLAN),m)
obj-m += conninfra.o
endif
