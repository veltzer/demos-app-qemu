#!/bin/bash -ex

source defs.sh

qemu-system-${ARCH}\
	-machine "${QEMU_MACHINE_TYPE}"\
	-kernel "${KERNEL_IMAGE}"\
	-audio driver=none,model=hda\
	-nographic\
	-dtb "build/${KERNEL_BUILD_FOLDER}/arch/arm/boot/dts/arm/versatile-pb.dtb"\
	-initrd "${INITRD_FULL_PATH}"\
	-append "rdinit=/init"
