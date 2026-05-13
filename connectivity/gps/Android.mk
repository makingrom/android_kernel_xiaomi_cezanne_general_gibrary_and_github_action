LOCAL_PATH := $(call my-dir)

ifeq ($(MTK_GPS_SUPPORT), yes)

# ======================== 关键修改 ========================
# GPS 内置时，不编译 gps_drv.ko
ifeq ($(CONFIG_MTK_COMBO_GPS),y)
$(warning GPS driver is built-in, skip gps_drv.ko)
else
# ==========================================================

include $(CLEAR_VARS)
LOCAL_MODULE := gps_drv.ko
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_INIT_RC := init.gps_drv.rc

ifneq (,$(filter MT6885 MT6893,$(MTK_PLATFORM)))
ifneq (,$(filter CONSYS_6885 CONSYS_6893,$(MTK_COMBO_CHIP)))
LOCAL_REQUIRED_MODULES := conninfra.ko
else
$(warning MTK_PLATFORM=$(MTK_PLATFORM), MTK_COMBO_CHIP=$(MTK_COMBO_CHIP))
$(warning gps_drv.ko does not claim the requirement for conninfra.ko)
endif
else
LOCAL_REQUIRED_MODULES := wmt_drv.ko
endif

include $(MTK_KERNEL_MODULE)

# ======================== 关闭判断 ========================
endif
# ==========================================================

endif
