#!/bin/bash -e

LOCAL_FOLDER="linux-4.4.157"
LOCAL_FILE="linux-4.4.157.tar.xz"
IMAGE="https://cdn.kernel.org/pub/linux/kernel/v4.x/${LOCAL_FILE}"

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
cp ../kernel_config "${LOCAL_FOLDER}/.config"
cd "${LOCAL_FOLDER}"
make
