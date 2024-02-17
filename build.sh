#!/bin/bash -ex

KERNEL_CONFIG=""

# shellcheck source=/dev/null
source "defs.sh"

REAL_ARCH=$(arch)

if [ ! -d build ]
then
	mkdir build
fi
cd build
if [ ! -f "${KERNEL_FILE}" ]
then
	wget "${KERNEL_DOWNLOAD}"
fi

if [ ! -d "${KERNEL_BUILD_FOLDER}" ]
then
	mkdir "${KERNEL_BUILD_FOLDER}"
	tar xvf "${KERNEL_FILE}" -C "${KERNEL_BUILD_FOLDER}" --strip-components=1
fi

cd "${KERNEL_BUILD_FOLDER}"
if [ ! -f "stamp" ]
then
	kernel_config="../../kernel_config.${ARCH}.${KERNEL_VERSION}.${KERNEL_CONFIG}"
	if [ ! -f "${kernel_config}" ]
	then
		echo "You are missing the kernel config file ${kernel_config}"
		exit 1
	fi
	cp "${kernel_config}" ".config"
	if [ "${REAL_ARCH}" != "${ARCH}" ]
	then
		make ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}"
	else
		make
	fi
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
	mv "${BUSYBOX_TAR_TOPLEVEL}" "${BUSYBOX_FOLDER}"
fi
cd "${BUSYBOX_FOLDER}"
if [ ! -f "stamp" ]
then
	# make defconfig
	cp "../../busybox_config.${ARCH}.${BUSYBOX_VERSION}.${BUSYBOX_CONFIG}" ".config"
	if [ "${REAL_ARCH}" != "${ARCH}" ]
	then
		make ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}"
		make ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" install
	else
		make
		make install
	fi
	touch stamp
fi
if [ ! -f "${INITRD}" ]
then
	cd _install
	mkdir -pv {proc,sys,dev,bin,sbin,usr}
	#cp ../../../init_scripts/rcS etc/init.d
	#cp ../../../init_scripts/init init
	find . -print0 | cpio --null --verbose --create --format=newc | gzip -9 > "../${INITRD}"

fi
cd ..
