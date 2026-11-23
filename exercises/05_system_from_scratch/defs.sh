# shellcheck shell=bash
# This file is sourced by build.sh, run.sh and others; the variables are read there, and are exported for the shell scripts they start.

ARCH="arm"
# ARCH="x86_64"

if [[ "${ARCH}" = "x86_64" ]]
then
export CROSS_COMPILE="x86_64-linux-gnu-"
KERNEL_VERSION="6.1.34"
KERNEL_DOWNLOAD_FOLDER="v6.x"
KERNEL_CONFIG="defconfig"
fi
if [[ "${ARCH}" = "arm" ]]
then
export CROSS_COMPILE="arm-linux-gnueabi-"
KERNEL_VERSION="6.7.4"
KERNEL_DOWNLOAD_FOLDER="v6.x"
KERNEL_CONFIG="versatile_defconfig"
fi

export MAKEFLAGS="-j4"
# export MAKEFLAGS=""

KERNEL_TAR_TOPLEVEL="linux-${KERNEL_VERSION}"
KERNEL_FILE="${KERNEL_TAR_TOPLEVEL}.tar.xz"
export KERNEL_DOWNLOAD="https://cdn.kernel.org/pub/linux/kernel/${KERNEL_DOWNLOAD_FOLDER}/${KERNEL_FILE}"
KERNEL_BUILD_FOLDER="linux-${KERNEL_VERSION}-${ARCH}-${KERNEL_CONFIG}"
if [[ "${ARCH}" = "x86_64" ]]
then
export KERNEL_IMAGE="build/${KERNEL_BUILD_FOLDER}/arch/x86/boot/bzImage"
fi
if [[ "${ARCH}" = "arm" ]]
then
export KERNEL_IMAGE="build/${KERNEL_BUILD_FOLDER}/arch/arm/boot/zImage"
fi

BUSYBOX_VERSION="1.36.1"
BUSYBOX_CONFIG="defconfig"
BUSYBOX_TAR_TOPLEVEL="busybox-${BUSYBOX_VERSION}"
BUSYBOX_FOLDER="busybox-${BUSYBOX_VERSION}-${ARCH}-${BUSYBOX_CONFIG}"
BUSYBOX_FILE="${BUSYBOX_TAR_TOPLEVEL}.tar.bz2"
export BUSYBOX_DOWNLOAD="https://busybox.net/downloads/${BUSYBOX_FILE}"

INITRD="initrd.cpio.gz"
export INITRD_FULL_PATH="build/${BUSYBOX_FOLDER}/${INITRD}"

# $ qemu-system-${ARCH} -machine help
# to see all machine types
if [[ "${ARCH}" = "x86_64" ]]
then
export QEMU_MACHINE_TYPE="ubuntu"
fi
if [[ "${ARCH}" = "arm" ]]
then
export QEMU_MACHINE_TYPE="versatilepb"
fi
