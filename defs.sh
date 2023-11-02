ARCH="arm"
ARCH="x86_64"
#CROSS_COMPILE="arm-linux-gnueabi-"
CROSS_COMPILE="arm-linux-gnueabihf-"

export MAKEFLAGS="-j4"
export MAKEFLAGS=""

KERNEL_VERSION="6.1.34"
KERNEL_DOWNLOAD_FOLDER="v6.x"
# KERNEL_CONFIG="allnoconfig"
KERNEL_CONFIG="defconfig"
KERNEL_TAR_TOPLEVEL="linux-${KERNEL_VERSION}"
KERNEL_FOLDER="linux-${KERNEL_VERSION}-${KERNEL_CONFIG}"
KERNEL_FILE="${KERNEL_TAR_TOPLEVEL}.tar.xz"
KERNEL_DOWNLOAD="https://cdn.kernel.org/pub/linux/kernel/${KERNEL_DOWNLOAD_FOLDER}/${KERNEL_FILE}"
# x86
KERNEL_IMAGE="build/${KERNEL_FOLDER}/arch/x86/boot/bzImage"
# ARM
# KERNEL_IMAGE="build/${KERNEL_FOLDER}/arch/arm/boot/zImage"

BUSYBOX_VERSION="1.36.1"
BUSYBOX_CONFIG="defconfig"
BUSYBOX_TAR_TOPLEVEL="busybox-${BUSYBOX_VERSION}"
BUSYBOX_FOLDER="busybox-${BUSYBOX_VERSION}-${BUSYBOX_CONFIG}"
BUSYBOX_FILE="${BUSYBOX_TAR_TOPLEVEL}.tar.bz2"
BUSYBOX_DOWNLOAD="https://busybox.net/downloads/${BUSYBOX_FILE}"

INITRD="initrd.cpio.gz"
INITRD_FULL_PATH="build/${BUSYBOX_FOLDER}/${INITRD}"

# $ qemu-system-${ARCH} -machine help
# to see all machine types
QEMU_MACHINE_TYPE="q35" # x86_64 type machine
# QEMU_MACHINE_TYPE="virt" # arm type machine
