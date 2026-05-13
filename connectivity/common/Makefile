MTK_PLATFORM := $(subst ",,$(CONFIG_MTK_PLATFORM))

CONNSYS_PLATFORM := $(TARGET_BOARD_PLATFORM_WMT)
PRIORITY_TABLE_MTK_PLATFORM := mt6735

ifeq ($(CONNSYS_PLATFORM),)
CONNSYS_PLATFORM := $(MTK_PLATFORM)
else
ifneq ($(filter $(PRIORITY_TABLE_MTK_PLATFORM), $(MTK_PLATFORM)),)
CONNSYS_PLATFORM := $(MTK_PLATFORM)
endif
endif

###############################################################################
# Necessary Check
ifneq ($(CONFIG_MTK_COMBO),)

ifneq ($(KERNEL_OUT),)
    ccflags-y += -imacros $(KERNEL_OUT)/include/generated/autoconf.h
endif

ifeq ($(CONFIG_MTK_COMBO_CHIP),)
    $(error CONFIG_MTK_COMBO_CHIP not defined)
endif

ifeq ($(TARGET_BUILD_VARIANT),$(filter $(TARGET_BUILD_VARIANT),userdebug user))
endif

KBUILD_MODPOST_FAIL_ON_WARNINGS := y
###############################################################################

ifeq ($(CONFIG_ARM64), y)
    ccflags-y += -D CONFIG_MTK_WCN_ARM64
endif

ifeq ($(CONFIG_MTK_CONN_LTE_IDC_SUPPORT),y)
    ccflags-y += -D WMT_IDC_SUPPORT=1
else
    ccflags-y += -D WMT_IDC_SUPPORT=0
endif

ccflags-y += -D MTK_WCN_WMT_STP_EXP_SYMBOL_ABSTRACT

ccflags-y += -I$(srctree)/drivers/misc/mediatek/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat/$(MTK_PLATFORM)/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat/$(MTK_PLATFORM)/include/mach
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat
ccflags-y += -I$(srctree)/drivers/misc/mediatek/base/power/$(MTK_PLATFORM)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/base/power/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/base/power/include/clkbuf_v1
ccflags-y += -I$(srctree)/drivers/misc/mediatek/base/power/include/clkbuf_v1/$(MTK_PLATFORM)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/btif/common/inc
ifeq ($(strip $(MTK_PLATFORM)), mt6735)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/eccci1
ccflags-y += -I$(srctree)/drivers/misc/mediatek/eccci1/$(MTK_PLATFORM)
else
ccflags-y += -I$(srctree)/drivers/misc/mediatek/eccci
ccflags-y += -I$(srctree)/drivers/misc/mediatek/eccci/$(MTK_PLATFORM)
endif
ccflags-y += -I$(srctree)/drivers/misc/mediatek/eemcs
ccflags-y += -I$(srctree)/drivers/misc/mediatek/conn_md/include
ccflags-y += -I$(srctree)/drivers/misc/mediatek/mach/$(MTK_PLATFORM)/include/mach
ccflags-y += -I$(srctree)/drivers/misc/mediatek/emi/submodule
ccflags-y += -I$(srctree)/drivers/misc/mediatek/emi/$(MTK_PLATFORM)
ifeq ($(CONFIG_MTK_PMIC_CHIP_MT6359),y)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/pmic/include/mt6359
endif
ifeq ($(CONFIG_MTK_PMIC_CHIP_MT6359P),y)
ccflags-y += -I$(srctree)/drivers/misc/mediatek/pmic/include/mt6359p
endif
ccflags-y += -I$(srctree)/drivers/mmc/core
ccflags-y += -I$(srctree)/drivers/misc/mediatek/connectivity/common
ccflags-y += -I$(srctree)/drivers/misc/mediatek/include/mt-plat
###############################################################################

ccflags-y += -Werror

ifneq ($(filter "MT6628",$(CONFIG_MTK_COMBO_CHIP)),)
    ccflags-y += -D MT6628
    ccflags-y += -D MERGE_INTERFACE_SUPPORT
endif
ifneq ($(filter "MT6630",$(CONFIG_MTK_COMBO_CHIP)),)
    ccflags-y += -D MT6630
ifneq ($(CONFIG_ARCH_MT2601),y)
    ccflags-y += -D MERGE_INTERFACE_SUPPORT
endif
endif

ifneq ($(filter "MT6632",$(CONFIG_MTK_COMBO_CHIP)),)
    ccflags-y += -D MT6632
    ccflags-y += -D MERGE_INTERFACE_SUPPORT
endif

ifneq ($(filter MT6631,$(MTK_CONSYS_ADIE)),)
    ccflags-y += -D CONSYS_PMIC_CTRL_6635=0
else
    ccflags-y += -D CONSYS_PMIC_CTRL_6635=1
endif

###############################################################################
# 🔥 🔥 🔥 这里改成自动切换 内置/模块 🔥 🔥 🔥
###############################################################################
wmt_drv-objs += common_detect/wmt_detect_pwr.o
wmt_drv-objs += common_detect/wmt_detect.o
wmt_drv-objs += common_detect/sdio_detect.o
wmt_drv-objs += common_detect/mtk_wcn_stub_alps.o
wmt_drv-objs += common_detect/wmt_gpio.o
wmt_drv-objs += common_detect/drv_init/fm_drv_init.o
wmt_drv-objs += common_detect/drv_init/conn_drv_init.o
wmt_drv-objs += common_detect/drv_init/bluetooth_drv_init.o
wmt_drv-objs += common_detect/drv_init/wlan_drv_init.o
wmt_drv-objs += common_detect/drv_init/common_drv_init.o
wmt_drv-objs += common_detect/drv_init/gps_drv_init.o

wmt_drv-objs += common_main/platform/$(CONNSYS_PLATFORM).o
wmt_drv-objs += common_main/platform/wmt_plat_alps.o
wmt_drv-objs += common_main/platform/mtk_wcn_consys_hw.o
wmt_drv-objs += common_main/platform/mtk_wcn_cmb_hw.o
wmt_drv-objs += common_main/core/wmt_ic_6628.o
wmt_drv-objs += common_main/core/wmt_conf.o
wmt_drv-objs += common_main/core/stp_core.o
wmt_drv-objs += common_main/core/wmt_ctrl.o
wmt_drv-objs += common_main/core/wmt_func.o
wmt_drv-objs += common_main/core/wmt_core.o
wmt_drv-objs += common_main/core/psm_core.o
wmt_drv-objs += common_main/core/wmt_ic_soc.o
wmt_drv-objs += common_main/core/wmt_lib.o
wmt_drv-objs += common_main/core/wmt_ic_6620.o
wmt_drv-objs += common_main/core/stp_exp.o
wmt_drv-objs += common_main/core/wmt_ic_6632.o
wmt_drv-objs += common_main/core/wmt_exp.o
wmt_drv-objs += common_main/core/btm_core.o
wmt_drv-objs += common_main/core/wmt_ic_6630.o
wmt_drv-objs += common_main/linux/hif_sdio.o
wmt_drv-objs += common_main/linux/stp_dbg_soc.o
wmt_drv-objs += common_main/linux/stp_dbg_combo.o
wmt_drv-objs += common_main/linux/osal.o
wmt_drv-objs += common_main/linux/wmt_dev.o
wmt_drv-objs += common_main/linux/stp_sdio.o
wmt_drv-objs += common_main/linux/bgw_desense.o
wmt_drv-objs += common_main/linux/wmt_idc.o
wmt_drv-objs += common_main/linux/stp_uart.o
wmt_drv-objs += common_main/linux/wmt_dbg.o
wmt_drv-objs += common_main/linux/stp_dbg.o
wmt_drv-objs += common_main/linux/wmt_user_proc.o
wmt_drv-objs += common_main/linux/wmt_proc_dbg.o
wmt_drv-objs += common_main/linux/wmt_alarm.o

ifeq ($(CONFIG_MTK_CONNSYS_DEDICATED_LOG_PATH),y)
wmt_drv-objs += common_main/linux/fw_log_wmt.o
endif
wmt_drv-objs += common_main/linux/wmt_step.o

ifeq ($(CONFIG_MTK_BTIF),y)
wmt_drv-objs += common_main/linux/stp_btif.o
endif

wmt_drv-objs += debug_utility/ring.o
wmt_drv-objs += debug_utility/ring_emi.o
wmt_drv-objs += debug_utility/connsys_debug_utility.o

ifeq ($(TARGET_BUILD_VARIANT),eng)
wmt_drv-objs += test/wmt_step_test.o
endif

# ----------------------------------------------------------------------------
# 自动根据 CONFIG_MTK_COMBO_WLAN 切换内置/模块
# ----------------------------------------------------------------------------
ifeq ($(CONFIG_MTK_COMBO_WLAN),y)
obj-y += wmt_drv.o
else ifeq ($(CONFIG_MTK_COMBO_WLAN),m)
obj-m += wmt_drv.o
endif

endif
