#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#
# OrangeFox build vars: https://wiki.orangefox.tech/dev/build_vars
#

# Screen: 1600x2560 at 1:1 (theme/widen.py lays the theme out 1600 wide); no notch
OF_SCREEN_H := 2560
OF_STATUS_H := 80
OF_STATUS_INDENT_LEFT := 48
OF_STATUS_INDENT_RIGHT := 48
OF_HIDE_NOTCH := 1
OF_ALLOW_DISABLE_NAVBAR := 0
OF_USE_GREEN_LED := 0

# A/B with a separate recovery partition, virtual A/B
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_BLOCK_OPERATIONS_AFTER_ROM_FLASH := 1
OF_ENABLE_LPTOOLS := 1
OF_USE_DMCTL := 1
OF_ENABLE_ALL_PARTITION_TOOLS := 1

# Data
OF_UNBIND_SDCARD_F2FS := 1
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1
OF_UNMOUNT_SDCARDS_BEFORE_REBOOT := 1
OF_QUICK_BACKUP_LIST := /boot;/vendor_boot;/dtbo;/data;

# Misc
OF_ENABLE_FRP_ADDON := 1
OF_LOOP_DEVICE_ERRORS_TO_LOG := 1
OF_USE_LZ4_COMPRESSION := 1
OF_OPTIONS_LIST_NUM := 9
