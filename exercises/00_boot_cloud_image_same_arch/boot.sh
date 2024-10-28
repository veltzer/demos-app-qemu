#!/bin/bash -e
qemu-system-x86_64\
	-hda system.qcow2\
	-cdrom cloud-init.iso\
	-m 2G\
	-nographic\
	-enable-kvm\
	-net nic -net user,hostfwd=tcp::2222-:22
