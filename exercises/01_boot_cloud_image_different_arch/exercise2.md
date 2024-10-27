# Exercise: Running a Pre-built ARM64 System on AMD64

## Objective
Set up and run a pre-built ARM64 (aarch64) Ubuntu system on an AMD64 host using QEMU system emulation.

## Prerequisites
- An `AMD64/x86_64` Linux system
- At least `10GB` of free disk space
- At least `2GB` of RAM available for the virtual machine

## Exercise Steps

1. Install required packages

```bash
sudo apt-get update
sudo apt-get install qemu-system-arm qemu-utils wget
```

2. Download the pre-built Ubuntu ARM64 image and UEFI firmware

```bash
# Download the pre-built Ubuntu ARM64 image
wget https://cdimage.ubuntu.com/ubuntu-server/jammy/current/jammy-server-cloudimg-arm64.img

# Download the ARM64 UEFI firmware
wget https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd
```

3. Convert and resize the image (cloud images are typically small by default)

```bash
# Convert to qcow2 format if needed
qemu-img convert -f qcow2 -O qcow2 jammy-server-cloudimg-arm64.img ubuntu-arm64.qcow2

# Resize to 20GB
qemu-img resize ubuntu-arm64.qcow2 20G
```

4. Create a cloud-init configuration for first boot

```bash
cat > cloud-init.cfg <<EOF
#cloud-config
password: ubuntu
chpasswd: { expire: False }
ssh_pwauth: True
hostname: ubuntu-arm64
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
EOF

# Create a cloud-init disk
cloud-localds cloud-init.img cloud-init.cfg
```

5. Create a startup script named `start-arm64.sh`:

```bash
#!/bin/bash
qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a72 \
    -smp 2 \
    -m 2048 \
    -bios QEMU_EFI.fd \
    -drive if=virtio,file=ubuntu-arm64.qcow2,format=qcow2 \
    -drive if=virtio,format=raw,file=cloud-init.img \
    -nographic \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -device nec-usb-xhci \
    -device usb-kbd \
    -device usb-tablet
```

6. Make the script executable

```bash
chmod +x start-arm64.sh
```

## Expected Results
- The system should boot directly into Ubuntu ARM64
- Default login credentials: username `ubuntu`, password `ubuntu`
- You can verify you're running ARM64 with `uname -m` which should show `aarch64`
- The system should have network access through QEMU's user networking
- SSH access is available on port 2222 of your host machine

## Verification Steps

1. Start the VM:
```bash
./start-arm64.sh
```

2. Log in with username `ubuntu` and password `ubuntu`

3. Verify the system:
```bash
# Check architecture
uname -m
# Should output: aarch64

# Check CPU information
cat /proc/cpuinfo
# Should show ARM CPU information

# Check disk space
df -h
# Should show ~20GB available
```

## Common Issues and Solutions

1. If the system fails to boot:
    - Verify that virtualization is enabled in your BIOS
    - Check if your kernel supports ARM64 emulation
    - Ensure you have enough free RAM

2. If networking doesn't work:
    - Check if your host firewall is blocking QEMU
    - Verify the virtio-net device is properly initialized

3. If you can't connect via SSH:
    - Verify the VM has fully booted
    - Check if port 2222 is not in use on your host
    - Try: `ssh -p 2222 ubuntu@localhost`

## Optional Enhancements

1. Add a shared folder between host and guest:

```bash
-virtfs local,path=/path/to/share,mount_tag=host0,security_model=passthrough,id=host0
```

## Clean Up
To remove the virtual machine and associated files:

```bash
rm ubuntu-arm64.qcow2
rm QEMU_EFI.fd
rm cloud-init.img
rm cloud-init.cfg
rm start-arm64.sh
rm jammy-server-cloudimg-arm64.img
```
