#!/bin/bash
set -e

# Create folder estructure

# Configure HOOKs
sed "s/^HOOKS=.*/HOOKS=(systemd ostree autodetect keyboard sd-vconsole block modconf sd-encrypt filesystems fsck sd-shutdown)/g" -i /etc/mkinitcpio.conf
mkinitcpio -P

# OSTree: Prepare microcode and initramfs
moduledir=$(find /usr/lib/modules -mindepth 1 -maxdepth 1 -type d)
cat /boot/*-ucode.img /boot/initramfs-linux-fallback.img > ${moduledir}/initramfs.img


# Podman: native Overlay Diff for optimal Podman performance
