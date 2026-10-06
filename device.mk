#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/xiaomi/dizi

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm \
    product \
    recovery \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot \
    vendor_dlkm

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

# Boot control: the service is AOSP, the passthrough implementation
# (android.hardware.boot@1.0-impl-1.2-qti) is the dizi vendor blob in
# recovery/root/vendor/lib64/hw. Without it the recovery blocks forever
# waiting for IBootControl.
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-service

# Dynamic partitions and fastbootd
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot@1.1-impl-mock

# API levels
PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_TARGET_VNDK_VERSION := 33

# qcom decryption (prepdecrypt + the init services in device/qcom/twrp-common)
PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# OTA certs: Xiaomi (HyperOS)
PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/recovery/security/miui

# OrangeFox
$(call inherit-product, $(LOCAL_PATH)/fox_dizi.mk)

# Recovery ramdisk
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/recovery/root/,$(TARGET_COPY_OUT_RECOVERY)/root/)
