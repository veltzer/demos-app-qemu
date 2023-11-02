#!/bin/bash -e
cd "build"
if [ ! -d "linux-6.1.34" ]
then
	tar xvf "linux-6.1.34.tar.xz"
fi
cd "linux-6.1.34"
make mrproper
make defconfig
scripts/config --disable KEYS
scripts/config --enable BLK_DEV_RAM
scripts/config --set-str BLK_DEV_RAM_COUNT "16"
# scripts/config --set-str SYSTEM_TRUSTED_KEYS ""
# scripts/config --set-str SYSTEM_REVOCATIOND_KEYS ""
cp .config "../../kernel_config.x86_64.6.1.34.defconfig"
