# AERA Recovery device tree for Meizu 21 Pro

Meizu 21 Pro uses the recovery product name `meizu21Pro` and hardware identifier `m2481`.

It was announced in February 2024 and released in March 2024.

## Device specifications

Basic   | Spec Sheet
-------:|:-------------------------
SoC     | Snapdragon® 8 Gen 3 (SM8650)
CPU     | Octa-core CPU with 1x Cortex-X4 & 5x Cortex-A720 & 2x Cortex-A520
GPU     | Qualcomm® Adreno™ 750
Memory  | 12/16GB RAM (LPDDR5X)
Shipped Android Version | 14.0 with Flyme 10
Storage | 256/512GB
Battery | 5050mAh(typ), non-removable
Display | 1368x3192, 6.79", AMOLED, 1-120Hz dynamic, 1250nits peak brightness
Camera  | 50MP (main), 10MP (floating telephoto), 13MP (ultra-wide), 32MP (front)

## Bring-up configuration

The tested target is the locally built PixelOS 17 firmware with its matching
6.1 kernel and vendor modules. The local DroidSpaces kernel release is
`6.1.176-g19e9b13339e2`. Physical-device results are recorded below.

- Standalone A/B recovery, Android boot header v4, 100 MiB recovery partitions.
- Dynamic partitions with a 9 GiB super partition and ext4/EROFS mount entries.
- F2FS userdata, fscrypt v2 and wrapped-key metadata encryption.
- Installed OS properties loaded before starting Qualcomm KeyMint.
- Native adaptive UI for the 1368 x 3192 panel, Meizu brightness and haptics.
- Meizu Adreno 750 graphics drivers and allocator from the local PixelOS build.
- Recovery USB configuration for ADB, MTP, sideload and fastbootd.
- Post-decryption WLAN module loading, supplicant configuration and firmware paths.
- AERA Root Manager with the bundled `android14-6.1` modules for all three providers.

The recovery uses the kernel and boot-time modules supplied by the active ROM.
Its touchscreen coordinates use the kernel-reported ABS axis ranges. The local
PixelOS Goodix driver includes the m2481 coordinate-range correction.

The `libnativewindow.so` and `libui.so` graphics runtime comes from AERA's public
waffle reference tree at revision `5610a89a115c0aa3b1e87a6f6cdab08ce001d4eb`.
The GPU drivers, allocator, mapper, GPU firmware and WLAN configuration come from
the local Meizu firmware build. Their hashes are recorded in `blob-provenance.json`.

## Build it yourself
```
mkdir aera && cd aera
repo init --depth=1 -u https://github.com/AERA-Recovery/android_manifest.git -b aera-16.0
repo sync -c --no-clone-bundle --no-tags -j8
git clone -b aera-16.0 https://github.com/mxihan/android_device_meizu_meizu21Pro-AERA.git device/meizu/meizu21Pro
git -C bootable/recovery apply "$PWD/device/meizu/meizu21Pro/patches/aera-core-fixes.patch"
git -C external/lvgl apply "$PWD/device/meizu/meizu21Pro/patches/lvgl-bounds-fix.patch"
```

The patches were tested against recovery revision
`fac04635f28657cda467f3abb9ba6ebb6d52fa6e` and LVGL revision
`626794146201c14eb70e030ae188fcaa6c7d376f`. They provide the input, brightness,
decryption, WLAN and fastbootd compatibility fixes used by the tested image.

```
export AERA_BUILD_DEVICE=meizu21Pro
source build/envsetup.sh
lunch twrp_meizu21Pro-bp2a-eng
m -j12 recoveryimage
```

The image is written to `out/target/product/meizu21Pro/recovery.img`.
Use a fresh build shell so the guarded AERA settings are selected before envsetup.

## Hardware validation

Physical-device checks on 2026-11-14 confirmed touchscreen pattern entry,
brightness adjustment, power-key screen lock/wake, ADB, automatic metadata
decryption, pattern-based FBE user decryption and readable internal storage.
The saved WLAN profile connected with WPA2-PSK and obtained a DHCP address.
Fastbootd answered `getvar is-userspace` with `yes` and rebooted back to Recovery.
The R3 recovery partition was read back and its SHA256 matched the image.

The UI currently uses software DRM scanout. The vendor graphics allocator
requires further C++ runtime compatibility work.

Stock Flyme and other vendor/kernel combinations require their own validation.
The bundled Root Manager catalog is filtered to the device's 6.1 kernel family.

## Source attribution

This port starts from adontoo's `twrp-16` Meizu tree at revision
`c7cea8004036ca55bc3fce125080aa0ad7c28bac`. Its copyright notices identify the upstream authors.
[Original Meizu tree](https://github.com/adontoo/device_meizu_m2481-TWRP/tree/c7cea8004036ca55bc3fce125080aa0ad7c28bac)

Build and packaging conventions follow AERA's public Android 16 manifest and
SM8650 reference device tree.
[AERA manifest](https://github.com/AERA-Recovery/android_manifest/tree/aera-16.0)
[AERA waffle reference](https://github.com/AERA-Recovery/android_device_oneplus_waffle-AERA/tree/5610a89a115c0aa3b1e87a6f6cdab08ce001d4eb)

## Device picture

![Meizu 21Pro](https://fms.res.meizu.com/dms/2024/02/29/7d591b01-952f-4819-846d-379603a22221.png)

## Donate Link(This device tree is modify from YukongA dada )
https://afdian.com/a/YuKongA
