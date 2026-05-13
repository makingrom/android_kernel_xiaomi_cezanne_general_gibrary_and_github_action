LOCAL_PATH := $(call my-dir)

ifneq (,$(filter $(word 2,$(subst -, ,$(LINUX_KERNEL_VERSION))),$(subst /, ,$(LOCAL_PATH))))
ifeq ($(CONFIG_MTK_MET_DRV),y)
$(warning MET driver built-in, skip module)
else

include $(CLEAR_VARS)
LOCAL_MODULE := met.ko
LOCAL_STRIP_MODULE := true

include $(MTK_KERNEL_MODULE)

endif
endif # Kernel version matches current path
