# Exercise: Running ARM64 Ubuntu on AMD64 using QEMU

## Objective
Run an ARM64 (aarch64) Ubuntu system on an AMD64 host using QEMU system emulation and a pre-built cloud image.

## Prerequisites
- An `AMD64/x86_64` Linux system
- At least 10GB of free disk space
- At least 2GB of RAM available for the virtual machine

## Exercise Steps

1. Install required packages

```bash
sudo apt-get update
sudo apt-get install qemu-system-arm qemu-utils wget cloud-image-utils
```

1. Download required files

```bash
# Download Ubuntu ARM64 cloud image (it's in QCOW2 format despite the .img extension)
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img

# Download the ARM64 UEFI firmware (required for booting)
wget https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd
```

1. Prepare the disk image

```bash
# Copy the cloud image to our working image
cp jammy-server-cloudimg-arm64.img system.qcow2
# Resize it by 5GB
qemu-img resize system.qcow2 +5G
```

1. Create cloud-init configuration

```bash
# Create cloud-init config file
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

# Create cloud-init disk
cloud-localds cloud-init.img cloud-init.cfg
```

1. Create startup script

```bash
cat > boot.sh <<EOF
#!/bin/bash -e
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
EOF

chmod +x boot.sh
```

1. Start the virtual machine

```bash
./boot.sh
```

## Login Information
- Username: `ubuntu`
- Password: `ubuntu`
- SSH access: `ssh -p 2222 ubuntu@localhost`

## Verification Steps

After logging in, verify the system is running as ARM64:

```bash
# Check architecture
uname -m
# Should output: aarch64

# Check system information
cat /proc/cpuinfo
# Should show ARM CPU information

# Check disk space
df -h
# Should show ~20GB available
```

## Understanding Key Components

1. **Cloud Image**: The Ubuntu cloud image is a pre-built system image designed for virtual machines and cloud environments.

1. **UEFI Firmware**: QEMU_EFI.fd serves as the virtual machine's firmware/BIOS, necessary for booting the ARM64 system.

1. **Cloud-init**: Handles first-boot initialization, setting up the user account and initial configuration.

1. **QEMU Options Explained**:
    - `-M virt`: Uses QEMU's virtual machine platform for ARM64
    - `-cpu cortex-a72`: Emulates an ARM Cortex-A72 processor
    - `-smp 2`: Provides 2 CPU cores
    - `-m 2048`: Allocates 2GB RAM
    - `-nographic`: Runs in terminal mode
    - `hostfwd=tcp::2222-:22`: Forwards host port 2222 to guest port 22 (SSH)

## Common Issues and Solutions

1. Boot Failures:
    - Check if virtualization is enabled in BIOS
    - Ensure sufficient RAM is available
    - Verify all files (UEFI firmware, images) are present
1. Network Issues:
    - Check host firewall settings
    - Verify host port 2222 is not in use
    - Wait for complete boot before trying SSH

## Clean Up

To remove everything:

```bash
rm system.qcow2
rm QEMU_EFI.fd
rm cloud-init.img
rm cloud-init.cfg
rm start-arm64.sh
rm jammy-server-cloudimg-arm64.img
```
