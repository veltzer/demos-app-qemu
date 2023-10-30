#!/bin/bash -e

source defs.sh

# the -machine flag is a must flag
# use:
# $ qemu-system-arm -machine help
# to see the list of all supported machines
qemu-system-${ARCH}\
	-kernel "${KERNEL_IMAGE}"\
	-initrd "${ROOTFS_FULL_PATH}"\
	-machine q35
#	-machine virt
#	-nographic
#	-monitor stdio\
#	-D log.txt
#	-m 256\
#	-M virt\
#	-append "console=ttyAMA0 root=/dev/ram rdinit=/sbin/init"
##	-monitor\
# -virtfs local,path=<host_path_to_share>,security_model=passthrough,mount_tag=host_share
