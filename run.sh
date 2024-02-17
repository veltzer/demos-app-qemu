#!/bin/bash -ex

source defs.sh

# the -machine flag is a must flag
# use:
# $ qemu-system-arm -machine help
# to see the list of all supported machines
# qemu-system-${ARCH}\
# export QEMU_AUDIO_DRV=none
qemu-system-arm\
	-machine versatilepb\
	-kernel "${KERNEL_IMAGE}"\
	-audio driver=none,model=hda\
	-nographic\
	-dtb "build/${KERNEL_BUILD_FOLDER}/arch/arm/boot/dts/arm/versatile-pb.dtb"\
	-initrd "${INITRD_FULL_PATH}"\
	-append "rdinit=/init"

echo << EOS
	-serial mon:stdio\
	-append "serial=ttyAMA0"\
	-append "console=ttyAMA0"\
	-append 'console=ttyS0'\
	-machine "${QEMU_MACHINE_TYPE}"\
	-nodefaults\
	-audio-driver help\
	-soundhw none\
	-serial tty\
	-append "root=/dev/ram rdinit=/linuxrc"\
	-display curses\
	-monitor\
	-machine virt\
	-m 256\
	-M virt\
	-append "console=ttyAMA0 root=/dev/ram rdinit=/sbin/init"\
	-virtfs local,path=<host_path_to_share>,security_model=passthrough,mount_tag=host_share
EOS
