#!/bin/bash -ex

source defs.sh

# the -machine flag is a must flag
# use:
# $ qemu-system-arm -machine help
# to see the list of all supported machines
# qemu-system-${ARCH}\
qemu-system-armhf\
	-kernel "${KERNEL_IMAGE}"\
	-append "root=/dev/ram"\
	-initrd "${INITRD_FULL_PATH}"\
	-machine "${QEMU_MACHINE_TYPE}"\
	-append 'console=ttyS0'
#	-nographic\
#	-append "root=/dev/ram rdinit=/linuxrc"\
#	-append "init=/bin/sh"
#	-display curses
#	-serial tty
#-monitor\
#	-append "console=ttyAMA0"
#	-machine virt
#	-D log.txt
#	-m 256\
#	-M virt\
#	-append "console=ttyAMA0 root=/dev/ram rdinit=/sbin/init"
##	-monitor\
# -virtfs local,path=<host_path_to_share>,security_model=passthrough,mount_tag=host_share
