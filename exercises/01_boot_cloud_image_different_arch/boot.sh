#!/bin/bash
qemu-system-aarch64\
	-M virt\
	-cpu cortex-a72\
	-smp 2\
	-m 2048\
	-bios QEMU_EFI.fd\
	-drive if=virtio,file=system.qcow2,format=qcow2\
	-drive if=virtio,format=raw,file=cloud-init.iso\
	-nographic\
	-device virtio-net-pci,netdev=net0\
	-netdev user,id=net0,hostfwd=tcp::2222-:22\
	-device nec-usb-xhci\
	-device usb-kbd\
	-device usb-tablet\
	-serial mon:stdio
