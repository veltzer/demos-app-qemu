#!/bin/bash -ex

# shellcheck source=/dev/null
source defs.sh
: "${ARCH:?ARCH must be set}"
: "${QEMU_MACHINE_TYPE:?QEMU_MACHINE_TYPE must be set}"
: "${KERNEL_IMAGE:?KERNEL_IMAGE must be set}"
: "${KERNEL_BUILD_FOLDER:?KERNEL_BUILD_FOLDER must be set}"
: "${INITRD_FULL_PATH:?INITRD_FULL_PATH must be set}"
#	-dtb "dt.dtb"\

if [[ "${ARCH}" = "arm" ]]
then
	"qemu-system-${ARCH}"\
		-machine "${QEMU_MACHINE_TYPE}"\
		-kernel "${KERNEL_IMAGE}"\
		-nographic\
		-dtb "build/${KERNEL_BUILD_FOLDER}/arch/arm/boot/dts/arm/versatile-pb.dtb"\
		-initrd "${INITRD_FULL_PATH}"\
		-append "rdinit=/sbin/init"
#		-audio driver=none,model=hda\
fi
if [[ "${ARCH}" = "x86_64" ]]
then
	"qemu-system-${ARCH}"\
		-machine "${QEMU_MACHINE_TYPE}"\
		-kernel "${KERNEL_IMAGE}"\
		-audio driver=none,model=hda\
		-initrd "${INITRD_FULL_PATH}"\
		-append "root=/dev/ram rdinit=/init"
#		-nographic\
fi
