#!/system/bin/sh
# Copyright (C) 2026 AERA Recovery Project contributors
# SPDX-License-Identifier: Apache-2.0

log_file=/tmp/recovery.log
exec >> "$log_file" 2>&1
mount_root=/tmp/aera-prepdecrypt
system_mounted=0
vendor_mounted=0

cleanup() {
    cleanup_failed=0
    if [ "$system_mounted" = 1 ]; then
        if umount "$mount_root/system"; then
            system_mounted=0
        else
            cleanup_failed=1
        fi
    fi
    if [ "$vendor_mounted" = 1 ]; then
        if umount "$mount_root/vendor"; then
            vendor_mounted=0
        else
            cleanup_failed=1
        fi
    fi
    return "$cleanup_failed"
}
trap cleanup EXIT

read_property() {
    grep -m 1 "^$1=" "$2" 2>/dev/null | cut -d= -f2-
}

mount_partition() {
    partition=$1
    suffix=$(getprop ro.boot.slot_suffix)
    slot=$(getprop ro.boot.slot)
    if [ -z "$suffix" ] && [ -n "$slot" ]; then
        suffix="_$slot"
    fi

    for block in "/dev/block/mapper/${partition}${suffix}" \
                 "/dev/block/mapper/$partition" \
                 "/dev/block/by-name/${partition}${suffix}"; do
        if [ -b "$block" ] && mount -o ro "$block" "$mount_root/$partition"; then
            return 0
        fi
    done
    return 1
}

setprop crypto.ready 0
mkdir -p "$mount_root/system" "$mount_root/vendor"

# Logical mapper nodes are prepared by recovery after loading the ROM modules.
attempt=0
while [ "$attempt" -lt 30 ]; do
    if mount_partition system; then
        system_mounted=1
        break
    fi
    attempt=$((attempt + 1))
    sleep 1
done

for property_file in "$mount_root/system/system/build.prop" \
                     "$mount_root/system/system/etc/build.prop" \
                     "$mount_root/system/build.prop" \
                     "$mount_root/system/etc/build.prop"; do
    os_version=$(read_property ro.build.version.release "$property_file")
    patch_level=$(read_property ro.build.version.security_patch "$property_file")
    if [ -n "$os_version" ] && [ -n "$patch_level" ]; then
        break
    fi
done

if [ -z "$os_version" ] || [ -z "$patch_level" ]; then
    echo "E:Meizu prepdecrypt could not read the installed system version and patch level" >> "$log_file"
    exit 1
fi

if ! mount_partition vendor; then
    echo "E:Meizu prepdecrypt could not mount the installed vendor partition" >> "$log_file"
    exit 1
fi
vendor_mounted=1
vendor_patch=$(read_property ro.vendor.build.security_patch "$mount_root/vendor/build.prop")
if [ -z "$vendor_patch" ]; then
    vendor_patch=$(read_property ro.vendor.build.security_patch "$mount_root/vendor/etc/build.prop")
fi
if [ -z "$vendor_patch" ]; then
    echo "E:Meizu prepdecrypt could not read the installed vendor patch level" >> "$log_file"
    exit 1
fi

resetprop ro.build.version.release "$os_version" || exit 1
resetprop ro.build.version.security_patch "$patch_level" || exit 1
resetprop ro.vendor.build.security_patch "$vendor_patch" || exit 1
echo "I:Meizu prepdecrypt prepared Android $os_version, system patch $patch_level, vendor patch $vendor_patch" >> "$log_file"

# KeyMint starts only after the installed OS properties have been applied.
if ! cleanup; then
    echo "E:Meizu prepdecrypt could not release its temporary mounts" >> "$log_file"
    exit 1
fi
setprop crypto.ready 1
