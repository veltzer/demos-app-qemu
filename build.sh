#!/bin/bash -e

KERNEL_VERSION="6.1.34"
KERNEL_FOLDER="v6.x"
TYPE="allnoconfig"
ARCH="arm"
LOCAL_FOLDER="linux-${KERNEL_VERSION}"
LOCAL_FILE="${LOCAL_FOLDER}.tar.xz"
IMAGE="https://cdn.kernel.org/pub/linux/kernel/${KERNEL_FOLDER}/${LOCAL_FILE}"
STOP_AFTER_TAR=0

if [ ! -d build ]
then
	mkdir build
fi
cd build
if [ ! -f "${LOCAL_FILE}" ]
then
	wget "${IMAGE}"
fi

if [ ! -d "${LOCAL_FOLDER}" ]
then
	tar xvf "${LOCAL_FILE}"
fi

if [ "${STOP_AFTER_TAR}" = "1" ]
then
	echo "stopping because of flag"
	exit 1
fi

cd "${LOCAL_FOLDER}"
if [ ! -f "stamp" ]
then
	cp "../../kernel_config.${ARCH}.${KERNEL_VERSION}.${TYPE}" ".config"
	make ARCH="${ARCH}" CROSS_COMPILE=arm-linux-gnueabi-
	touch stamp
fi
