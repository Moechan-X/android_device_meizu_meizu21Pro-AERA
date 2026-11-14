#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/meizu/meizu21Pro

# Building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Rules
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_NINJA_USES_ENV_VARS += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

# Power
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Battery
AERA_CUSTOM_BATTERY_PATH := "/sys/class/power_supply/battery"
AERA_BATTERY_SYSFS_WAIT_SECONDS := 6

# Bootloader
PRODUCT_PLATFORM := pineapple
TARGET_BOOTLOADER_BOARD_NAME := pineapple
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Platform
TARGET_BOARD_PLATFORM := meizu_sm8650
TARGET_BOARD_PLATFORM_GPU := qcom-adreno750
QCOM_BOARD_PLATFORMS += meizu_sm8650

# Kernel
TARGET_KERNEL_ARCH            := arm64
TARGET_KERNEL_HEADER_ARCH     := arm64
BOARD_KERNEL_IMAGE_NAME       := Image
BOARD_BOOT_HEADER_VERSION     := 4
BOARD_KERNEL_PAGESIZE         := 4096
TARGET_KERNEL_CLANG_COMPILE   := true
BOARD_MKBOOTIMG_ARGS          += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS          += --pagesize $(BOARD_KERNEL_PAGESIZE)

# Ramdisk use lz4
BOARD_RAMDISK_USE_LZ4 := true

# A/B
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    recovery \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vendor \
    vendor_dlkm

# Verified Boot
BOARD_AVB_ENABLE := true

# Partitions
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Workaround for error copying vendor files to recovery ramdisk
TARGET_COPY_OUT_VENDOR := vendor

TARGET_COPY_OUT_ODM := odm
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USES_VENDOR_DLKMIMAGE := true
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600

# Dynamic Partition
BOARD_SUPER_PARTITION_SIZE := 9663676416
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9659482112
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_dlkm system_ext product vendor vendor_dlkm odm

# File systems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

#Init
TARGET_PLATFORM_DEVICE_BASE := /devices/soc/

# Extras
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab

# Crypto
AERA_INCLUDE_CRYPTO := true
AERA_INCLUDE_CRYPTO_FBE := true
AERA_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
BOARD_USES_METADATA_PARTITION := true
AERA_USE_FSCRYPT_POLICY := 2
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Tool
AERA_INCLUDE_REPACKTOOLS := true
AERA_INCLUDE_RESETPROP := true
AERA_INCLUDE_LIBRESETPROP := true
AERA_ENABLE_ALL_PARTITION_TOOLS := 1
AERA_USE_TOOLBOX := true
AERA_INCLUDE_7ZA := true
AERA_INCLUDE_ZSTD := true
AERA_INCLUDE_LPDUMP := true
AERA_INCLUDE_LPTOOLS := true

# F2FS
AERA_ENABLE_FS_COMPRESSION := 1

# Debug
TARGET_USES_LOGD := true
AERA_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace

# Build the Meizu RichTap HAL and its AIDL extension against this platform.
TARGET_RECOVERY_DEVICE_MODULES += android.hardware.vibrator.service.meizu-richtap
TARGET_RECOVERY_DEVICE_MODULES += vendor.aac.hardware.richtap.vibrator-V1-ndk
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/android.hardware.vibrator.service.meizu-richtap
RECOVERY_LIBRARY_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/vendor.aac.hardware.richtap.vibrator-V1-ndk.so

# The native-buffer graphics runtime uses the platform's matching AIDL types.
TARGET_RECOVERY_DEVICE_MODULES += android.hardware.graphics.common-V6-ndk
RECOVERY_LIBRARY_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.graphics.common-V6-ndk.so

# Fastbootd
AERA_INCLUDE_FASTBOOTD := true

# AERA display uses a 1080-wide reference for the 1368 x 3192 panel.
AERA_UI_ADAPTIVE_RESOLUTION := true
AERA_SCREEN_H := 2520
AERA_STATUS_H := 112
AERA_STATUS_INDENT_LEFT := 54
AERA_STATUS_INDENT_RIGHT := 54
AERA_THEME := portrait_hdpi
AERA_FRAMERATE := 120
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
AERA_EXCLUDE_DEFAULT_USB_INIT := true
AERA_SKIP_ADDITIONAL_FSTAB := true
AERA_INCLUDE_NTFS_3G := true
AERA_NO_EXFAT_FUSE := true
AERA_USE_DMCTL := true
TARGET_USES_MKE2FS := true
AERA_INCLUDE_FUSE_EXFAT := true
AERA_INCLUDE_FUSE_NTFS := true
AERA_INPUT_BLACKLIST := "hbtp_vm"
AERA_BRIGHTNESS_PATH := /sys/class/backlight/panel0-backlight/brightness
AERA_MAX_BRIGHTNESS := 4095
AERA_EXTRA_LANGUAGES := true
AERA_DEFAULT_LANGUAGE := zh_CN
AERA_DEFAULT_BRIGHTNESS := 2048
AERA_EXCLUDE_APEX := true
AERA_HAS_EDL_MODE := true
AERA_SUPPORT_INPUT_AIDL_HAPTICS := true
AERA_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
# Turn off the backlight for screen sleep while keeping Goodix reporting.
# The power key wakes recovery and restores the saved brightness.
AERA_NO_SCREEN_BLANK := true

# Resolve drivers from the active ROM so they follow its running kernel ABI.
AERA_LOAD_VENDOR_MODULES := "smcinvoke_dlkm.ko qseecom_dlkm.ko msm_kgsl.ko goodix_ts.ko cs_press_m68.ko adsp_loader_dlkm.ko"
AERA_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true
AERA_LOAD_VENDOR_BOOT_MODULES := true
AERA_POST_DECRYPT_MODULES := "gsim.ko rmnet_mem.ko ipam.ko cnss_prealloc.ko cnss_nl.ko wlan_firmware_service.ko cnss_plat_ipc_qmi_svc.ko cnss_utils.ko cnss2.ko rfkill.ko cfg80211.ko qca_cld3_kiwi_v2.ko"
AERA_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone47/temp"
AERA_BACKUP_EXCLUSIONS := /data/fonts
AERA_DEVICE_VERSION := Meizu_21Pro
AERA_ENABLE_WLAN := 1
AERA_ROOT_MODULE_KERNELS := 6.1
