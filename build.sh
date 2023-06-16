#!/bin/bash -e

KERNEL_VERSION="6.1.34"
KERNEL_FOLDER="v6.x"
KERNEL_TYPE="allnoconfig"
KERNEL_ARCH="arm"
KERNEL_FOLDER="linux-${KERNEL_VERSION}"
KERNEL_FILE="${KERNEL_FOLDER}.tar.xz"
KERNEL_DOWNLOAD="https://cdn.kernel.org/pub/linux/kernel/${KERNEL_FOLDER}/${KERNEL_FILE}"
STOP_AFTER_TAR="0"

BUSYBOX_VERSION="1.36.1"
BUSYBOX_FOLDER="busybox-${BUSYBOX_VERSION}"
BUSYBOX_FILE="${BUSYBOX_FOLDER}.tar.bz2"
BUSYBOX_DOWNLOAD="https://busybox.net/downloads/${BUSYBOX_FILE}"

if [ ! -d build ]
then
	mkdir build
fi
cd build
if [ ! -f "${KERNEL_FILE}" ]
then
	wget "${KERNEL_DOWNLOAD}"
fi

if [ ! -d "${KERNEL_FOLDER}" ]
then
	tar xvf "${KERNEL_FILE}"
fi

if [ "${STOP_AFTER_TAR}" = "1" ]
then
	echo "stopping because of flag"
	exit 1
fi

cd "${KERNEL_FOLDER}"
if [ ! -f "stamp" ]
then
	cp "../../kernel_config.${KERNEL_ARCH}.${KERNEL_VERSION}.${KERNEL_TYPE}" ".config"
	make ARCH="${KERNEL_ARCH}" CROSS_COMPILE=arm-linux-gnueabi-
	touch stamp
fi
cd ..

if [ ! -f "${BUSYBOX_FILE}" ]
then
	wget "${BUSYBOX_DOWNLOAD}"
fi

if [ ! -d "${BUSYBOX_FOLDER}" ]
then
	tar xvf "${BUSYBOX_FILE}"
fi
cd "${BUSYBOX_FOLDER}"
if [ ! -f "stamp" ]
then
	make defconfig
	make CROSS_COMPILE=arm-linux-gnueabi-
	make install CROSS_COMPILE=arm-linux-gnueabi-
	touch stamp
fi
cd ..
