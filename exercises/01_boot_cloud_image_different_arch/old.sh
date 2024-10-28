#!/bin/bash -e
qemu-system-aarch64\
	-M virt\
	-cpu cortex-a72\
	-smp 2\
	-m 2048\
	-bios QEMU_EFI.fd\
	-drive if=virtio,file=system.qcow2,format=qcow2\
	-drive format=raw,file=cloud-init.iso\
	-nographic\
	-device virtio-net-pci,netdev=net0\
	-netdev user,id=net0,hostfwd=tcp::2222-:22\
	-serial none\
	-monitor stdio
#	-monitor telnet:127.0.0.1:4444,server,nowait \
#	-serial telnet:127.0.0.1:4445,server,nowait
#	-serial mon:stdio\
