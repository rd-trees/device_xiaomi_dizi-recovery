# OrangeFox recovery for the Redmi Pad Pro (dizi)

OrangeFox (fox_16.0) device tree for the Xiaomi Redmi Pad Pro / POCO Pad, codename
`dizi` (SM7435 "parrot", A/B with a recovery partition, virtual A/B).

Based on the OrangeFox garnet fox_16.0 tree and sm84xx-common (same SoC), made
self-contained and adapted to dizi.

## Status

Tested on a Redmi Pad Pro (2405CRPFDG) with HyperOS 3 firmware (OS3.0.303) and
Evolution X 17 installed:

| Feature | Status |
|---|---|
| Boot, display, touch | Works |
| Data decryption (FBEv2 wrapped keys + metadata encryption) | Works with no lock-screen credential; a PIN or password is not tested yet |
| adb, MTP | Works, without having to replug the cable |
| ROM zip flashing (A/B payload) with "reflash OrangeFox" | Works |
| Image flashing, backup and restore, fastbootd, adb sideload | Not tested yet |
| Haptics | Disabled |

## How it fits dizi

- **Kernel and modules:** the recovery image has no kernel. The bootloader boots it with
  the kernel from `boot_<slot>`, and first-stage init loads the recovery modules from
  `vendor_boot`. Touch (Novatek NT36532), charger and ADSP therefore always match the
  installed ROM. `prebuilt/kernel` is only there to satisfy the build.
- **Decryption:** uses dizi's own vendor qseecomd, KeyMint 1 and Gatekeeper 1.0
  from HyperOS 3, in `recovery/root`. The vendor VINTF manifest deliberately has no
  Keymaster 4.x entry. With one, keystore2, and with it the recovery, waits forever
  for a HAL that does not exist on dizi.
- **Boot control:** the AOSP boot@1.2 service with dizi's vendor passthrough implementation.
- **USB:** the dwc3 controller can miss the cable attach. `usb_attach.sh` cycles the
  controller mode until the gadget is configured, every time the USB config changes.
- **Layout:** the OrangeFox theme is drawn on a 1080 px phone grid. Scaled up, it would be
  1.48x too large on this 1600x2560 tablet. `theme/widen.py` instead lays it out
  1600 px wide at 1:1 when the image is built, splash included.

## Building

```bash
mkdir orangefox && cd orangefox
repo init --depth=1 -u https://gitlab.com/OrangeFox/Manifest.git -b fox_16.0
mkdir -p .repo/local_manifests
curl -o .repo/local_manifests/dizi.xml \
    https://raw.githubusercontent.com/rd-trees/device_xiaomi_dizi-recovery/fox_16.0/dizi.xml
repo sync -c --no-clone-bundle --no-tags

export FOX_BUILD_DEVICE=dizi ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
source device/xiaomi/dizi/vendorsetup.sh
lunch twrp_dizi-bp2a-eng
mka recoveryimage
```

The output is `out/target/product/dizi/recovery.img`, plus the OrangeFox installer zip.

## Installing

From the bootloader (fastboot):

```bash
fastboot flash recovery_a recovery.img
fastboot flash recovery_b recovery.img
fastboot reboot recovery
```

When flashing a ROM from OrangeFox, keep "Reflash OrangeFox after flashing a ROM" on.
Otherwise the ROM's own recovery replaces OrangeFox on the updated slot.
