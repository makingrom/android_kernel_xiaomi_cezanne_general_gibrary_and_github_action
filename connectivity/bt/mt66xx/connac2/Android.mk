LOCAL_PATH := $(call my-dir)

ifneq (true,$(strip $(TARGET_NO_KERNEL)))
# ========================= 关键修改 =========================
# 【内置模式时，不编译 bt_drv.ko 模块】
ifeq ($(CONFIG_MTK_COMBO_BT),y)
$(warning BT driver is built-in, skip bt_drv.ko build)
else
# ============================================================
ifeq ($(MTK_BT_CHIP), $(filter $(MTK_BT_CHIP), MTK_CONSYS_MT6885 MTK_CONSYS_MT6893))

include $(CLEAR_VARS)
LOCAL_MODULE := bt_drv.ko
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := mtk

LOCAL_INIT_RC := init.bt_drv.rc
LOCAL_SRC_FILES := $(patsubst $(LOCAL_PATH)/%,%,$(shell find $(LOCAL_PATH) -type f -name '*.[cho]')) Makefile
LOCAL_REQUIRED_MODULES := conninfra.ko

include $(MTK_KERNEL_MODULE)

BT_OPTS += CFG_BT_PM_QOS_CONTROL=y
BT_OPTS += _MTK_BT_CHIP=$(MTK_BT_CHIP)
BT_OPTS += _MTK_PLAT_MT6885_EMULATION=$(MTK_PLAT_MT6885_EMULATION)
$(linked_module): OPTS += $(BT_OPTS)
endif
endif
endif
