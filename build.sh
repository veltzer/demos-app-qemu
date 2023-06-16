#!/bin/bash -e

ARCH="arm"
CROSS_COMPILE="arm-linux-gnueabi-"

KERNEL_VERSION="6.1.34"
KERNEL_FOLDER="v6.x"
KERNEL_TYPE="allnoconfig"
KERNEL_FOLDER="linux-${KERNEL_VERSION}"
KERNEL_FILE="${KERNEL_FOLDER}.tar.xz"
KERNEL_DOWNLOAD="https://cdn.kernel.org/pub/linux/kernel/${KERNEL_FOLDER}/${KERNEL_FILE}"

BUSYBOX_VERSION="1.36.1"
BUSYBOX_FOLDER="busybox-${BUSYBOX_VERSION}"
BUSYBOX_FILE="${BUSYBOX_FOLDER}.tar.bz2"
BUSYBOX_DOWNLOAD="https://busybox.net/downloads/${BUSYBOX_FILE}"
BUSYBOX_TYPE="defconfig"

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

cd "${KERNEL_FOLDER}"
if [ ! -f "stamp" ]
then
	# make allnoconfig
	cp "../../kernel_config.${ARCH}.${KERNEL_VERSION}.${KERNEL_TYPE}" ".config"
	make ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}"
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
	# make defconfig
	cp "../../busybox_config.${ARCH}.${BUSYBOX_VERSION}.${BUSYBOX_TYPE}" ".config"
	make ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}"
	make ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" install
	touch stamp
fi
cd ..
