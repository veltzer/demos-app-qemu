#!/bin/bash -e

# copy stuff from /boot to be able to run the host images

ARCH=$(arch)
KERNEL_VERSION=$(uname -r)

sudo cp "/boot/vmlinuz" "/boot/initrd.img" build
sudo chown "$USER:$USER" "build/vmlinuz" "build/initrd.img"
