#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from the device.
$(call inherit-product, device/xiaomi/dizi/device.mk)

PRODUCT_DEVICE := dizi
PRODUCT_NAME := twrp_dizi
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Pad Pro
PRODUCT_MANUFACTURER := Xiaomi
