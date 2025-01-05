#!/bin/bash -ex

source defs.sh
#	-dtb "dt.dtb"\

if [ "$ARCH" = "arm" ]
then
	qemu-system-${ARCH}\
		-machine "${QEMU_MACHINE_TYPE}"\
		-kernel "${KERNEL_IMAGE}"\
		-nographic\
		-dtb "build/${KERNEL_BUILD_FOLDER}/arch/arm/boot/dts/arm/versatile-pb.dtb"\
		-initrd "${INITRD_FULL_PATH}"\
		-append "rdinit=/sbin/init"
#		-audio driver=none,model=hda\
fi
if [ "$ARCH" = "x86_64" ]
then
	qemu-system-${ARCH}\
		-machine "${QEMU_MACHINE_TYPE}"\
		-kernel "${KERNEL_IMAGE}"\
		-audio driver=none,model=hda\
		-initrd "${INITRD_FULL_PATH}"\
		-append "root=/dev/ram rdinit=/init"\
#		-nographic\
fi
