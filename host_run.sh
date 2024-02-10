#!/bin/bash -e

# run qemu with the host image and initrd

ARCH=$(arch)
# KERNEL_VERSION=$(uname -r)

qemu-system-${ARCH}\
	-kernel "/boot/vmlinuz"\
	-initrd "/boot/initrd.img"\
	-append "root=/dev/ram"\
	-m 2G\
	-nographic\
	-append 'console=ttyS0'
