# Exercise: Setting up and Running an ARM64 System on AMD64

## Objective
Set up and run a complete ARM64 (aarch64) Ubuntu system on an AMD64 host using QEMU system emulation.

## Prerequisites
- An AMD64/x86_64 Linux system
- At least 4GB of free disk space
- At least 2GB of RAM available for the virtual machine

## Exercise Steps

1. Install required packages

```bash
sudo apt-get update
sudo apt-get install qemu-system-arm qemu-efi-aarch64 qemu-utils
```

1. Download Ubuntu ARM64 server image

```bash
wget https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/jammy-live-server-arm64.iso
```

1. Create a virtual disk

```bash
qemu-img create -f qcow2 ubuntu-arm64.qcow2 20G
```

1. Download the ARM64 UEFI firmware

```bash
wget https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd
```

1. Create a startup script named `start-arm64.sh`:

```bash
#!/bin/bash
qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a72 \
    -smp 2 \
    -m 2048 \
    -bios QEMU_EFI.fd \
    -drive if=virtio,file=ubuntu-arm64.qcow2,format=qcow2 \
    -drive if=virtio,format=raw,file=jammy-live-server-arm64.iso \
    -nographic \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0 \
    -device nec-usb-xhci \
    -device usb-kbd \
    -device usb-tablet
```

1. Make the script executable

```bash
chmod +x start-arm64.sh
```

## Expected Results
- The system should boot into the Ubuntu ARM64 installer
- You can verify you're running ARM64 with `uname -m` which should show `aarch64`
- The system should have network access through QEMU's user networking

## Solution and Explanation

1. First, let's understand the QEMU command options:
    - `-M virt`: Uses the `virt` machine type, which is a virtual platform for ARM64
    - `-cpu cortex-a72`: Emulates a Cortex-A72 processor
    - `-smp 2`: Allocates 2 virtual CPU cores
    - `-m 2048`: Allocates 2GB of RAM
    - `-bios QEMU_EFI.fd`: Uses the UEFI firmware for booting
    - The drive configurations use virtio for better performance

1. To install the system:
    - Run `./start-arm64.sh`
    - Follow the Ubuntu server installation process
    - When installation completes, shut down the VM

1. To boot from the installed system, modify the script to remove the ISO:

```bash
#!/bin/bash
qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a72 \
    -smp 2 \
    -m 2048 \
    -bios QEMU_EFI.fd \
    -drive if=virtio,file=ubuntu-arm64.qcow2,format=qcow2 \
    -nographic \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0 \
    -device nec-usb-xhci \
    -device usb-kbd \
    -device usb-tablet
```

1. Verification steps:

```bash
# Check architecture
uname -m
# Should output: aarch64

# Check CPU information
cat /proc/cpuinfo
# Should show ARM CPU information

# Test system performance
dd if=/dev/zero of=test bs=1M count=1024
# This will show you the disk I/O performance
```

## Common Issues and Solutions

1. If the system fails to boot:
    - Verify that virtualization is enabled in your BIOS
    - Check if your kernel supports ARM64 emulation
    - Ensure you have enough free RAM

1. If networking doesn't work:
    - Check if your host firewall is blocking QEMU
    - Verify the virtio-net device is properly initialized

1. If the system is slow:
    - Try reducing the number of virtual CPUs or RAM
    - Use virtio drivers where possible
    - Consider enabling KVM if your CPU supports it

## Optional Enhancements

1. Add port forwarding for SSH access:

```bash
-netdev user,id=net0,hostfwd=tcp::2222-:22
```

1. Add a shared folder between host and guest:

```bash
-virtfs local,path=/path/to/share,mount_tag=host0,security_model=passthrough,id=host0
```

## Clean Up
To remove the virtual machine:

```bash
rm ubuntu-arm64.qcow2
rm QEMU_EFI.fd
rm jammy-live-server-arm64.iso
rm start-arm64.sh
```
