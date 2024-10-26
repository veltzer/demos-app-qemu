#!/bin/bash -e

# copy stuff from /boot to be able to run the host images

ARCH=$(arch)
# KERNEL_VERSION=$(uname -r)
KERNEL_VERSION="6.2.0-1005-lowlatency"

mkdir -p build
sudo cp "/boot/vmlinuz-${KERNEL_VERSION}" "build/vmlinuz"
sudo cp "/boot/initrd.img-${KERNEL_VERSION}" "build/initrd.img"
sudo chown "$USER:$USER" "build/vmlinuz" "build/initrd.img"
