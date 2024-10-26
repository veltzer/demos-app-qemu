#!/bin/bash -e
cd "build"
if [ ! -d "linux-6.1.34" ]
then
	tar xvf "linux-6.1.34.tar.xz"
fi
cd "linux-6.1.34"
make mrproper
make defconfig

# disable keys (needed for large kernels)
scripts/config --disable KEYS

# enable /dev/ram?
scripts/config --enable BLK_DEV_RAM
scripts/config --set-val BLK_DEV_RAM_COUNT 16
scripts/config --set-val BLK_DEV_RAM_SIZE 4096

cp .config "../../kernel_config.x86_64.6.1.34.defconfig"
