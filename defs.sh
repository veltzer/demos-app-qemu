ARCH="arm"
ARCH="x86_64"
#CROSS_COMPILE="arm-linux-gnueabi-"
CROSS_COMPILE="arm-linux-gnueabihf-"
ROOTFS="rootfs.img"

KERNEL_VERSION="6.1.34"
KERNEL_DOWNLOAD_FOLDER="v6.x"
KERNEL_TYPE="allnoconfig"
KERNEL_FOLDER="linux-${KERNEL_VERSION}"
KERNEL_FILE="${KERNEL_FOLDER}.tar.xz"
KERNEL_DOWNLOAD="https://cdn.kernel.org/pub/linux/kernel/${KERNEL_DOWNLOAD_FOLDER}/${KERNEL_FILE}"
# x86
KERNEL_IMAGE="build/${KERNEL_FOLDER}/arch/x86/boot/bzImage"
# ARM
# KERNEL_IMAGE="build/${KERNEL_FOLDER}/arch/arm/boot/zImage"
KERNEL_BUILD_FLAGS="-j4"

BUSYBOX_VERSION="1.36.1"
BUSYBOX_FOLDER="busybox-${BUSYBOX_VERSION}"
BUSYBOX_FILE="${BUSYBOX_FOLDER}.tar.bz2"
BUSYBOX_DOWNLOAD="https://busybox.net/downloads/${BUSYBOX_FILE}"
BUSYBOX_TYPE="defconfig"

ROOTFS_FULL_PATH="build/${BUSYBOX_FOLDER}/${ROOTFS}"
