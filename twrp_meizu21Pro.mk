#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/meizu/meizu21Pro

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Release name
PRODUCT_RELEASE_NAME := meizu21Pro

## Device identifier
PRODUCT_DEVICE := meizu21Pro
PRODUCT_NAME := twrp_meizu21Pro
PRODUCT_BRAND := meizu
PRODUCT_MODEL := Meizu 21Pro
PRODUCT_MANUFACTURER := meizu

# Assert
TARGET_OTA_ASSERT_DEVICE := meizu21Pro,m2481

# Theme
AERA_STATUS_ICONS_ALIGN := center
