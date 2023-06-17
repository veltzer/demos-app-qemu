#!/bin/bash -e

source defs.sh

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
if [ ! -f "${ROOTFS}" ]
then
	cd _install
	mkdir -p etc/init.d
	cp ../../../rcS etc/init.d
	find . | cpio -o --format=newc > "../${ROOTFS}"
fi
cd ..
