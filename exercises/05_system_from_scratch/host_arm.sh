#!/bin/bash -e

# run qemu with the host image and initrd

qemu-system-arm\
	-kernel "build/zImage"\
	-M virt\
	-initrd "build/initrd.cpio.gz"\
	-m 2G\
	-append 'console=ttyS0'
# -append "root=/dev/ram"\
# -nographic\
