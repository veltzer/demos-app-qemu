#!/bin/bash -e

if [ ! -f system.qcow2 ]
then
	wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img -O system.qcow2 
	qemu-img resize system.qcow2 +5G
fi

if [ ! -f QEMU_EFI.fd ]
then
	wget https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd
fi

if [ ! -f cloud-init.iso ]
then
	cloud-localds cloud-init.iso cloud-init.yaml
fi
