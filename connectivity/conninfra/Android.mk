LOCAL_PATH := $(call my-dir)

ifneq ($(filter yes,$(sort $(MTK_WLAN_SUPPORT) $(MTK_BT_SUPPORT) $(MTK_GPS_SUPPORT) $(MTK_FM_SUPPORT))),)

ifneq (true,$(strip $(TARGET_NO_KERNEL)))
ifneq ($(filter yes,$(MTK_COMBO_SUPPORT)),)

# ======================== 关键修改 ========================
# 当 WLAN 内置时，不编译 conninfra.ko
ifeq ($(CONFIG_MTK_COMBO_WLAN),y)
$(warning CONNINFRA is built-in, skip conninfra.ko)
else
# ==========================================================

include $(CLEAR_VARS)
LOCAL_MODULE := conninfra.ko
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := mtk

LOCAL_INIT_RC := init.conninfra.rc
LOCAL_SRC_FILES := $(patsubst $(LOCAL_PATH)/%,%,$(shell find $(LOCAL_PATH) -type f -name '*.[cho]')) Makefile
LOCAL_REQUIRED_MODULES :=

include $(MTK_KERNEL_MODULE)

CONNINFRA_OPTS := TARGET_BOARD_PLATFORM_CONNINFRA=$(TARGET_BOARD_PLATFORM)
$(linked_module): OPTS += $(CONNINFRA_OPTS)

# ======================== 关闭判断 ========================
endif
# ==========================================================

else
        $(warning wmt_drv-MTK_COMBO_SUPPORT: [$(MTK_COMBO_SUPPORT)])
endif
endif

endif
