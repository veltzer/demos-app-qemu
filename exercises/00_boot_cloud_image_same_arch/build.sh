#!/bin/bash -e

if [ ! -f system.qcow2 ]
then
	wget https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2 -O system.qcow2
	qemu-img resize system.qcow2 +5G
fi
if [ ! -f cloud-init.iso ]
then
	cloud-localds cloud-init.iso cloud-init.yaml
fi
