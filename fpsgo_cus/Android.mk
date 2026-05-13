LOCAL_PATH := $(call my-dir)

ifeq (,$(wildcard $(LOCAL_PATH)/../fpsgo_int))

ifeq ($(CONFIG_MTK_FPSGO),y)
$(warning FPSGO built-in, skip fpsgo.ko)
else

include $(CLEAR_VARS)
LOCAL_MODULE := fpsgo.ko
include $(MTK_KERNEL_MODULE)

endif
endif
