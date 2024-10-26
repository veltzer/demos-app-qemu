# QEMU Exercise: Building and Booting a Custom BusyBox Userspace (No Kernel Build)

## Objective
Build a minimal Linux userspace environment using BusyBox, create a disk image, and boot it using QEMU with a pre-built kernel.

## Prerequisites
- Linux development environment
- QEMU installed
- Basic knowledge of Linux commands

## Exercise Steps

### 1. Build BusyBox

1.1. Download BusyBox:
```bash
wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2
tar xjf busybox-1.35.0.tar.bz2
cd busybox-1.35.0
```

1.2. Configure BusyBox:
```bash
make defconfig
```

1.3. Modify the configuration to build static binaries:
```bash
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
```

1.4. Build BusyBox:
```bash
make -j$(nproc)
```

1.5. Install BusyBox:
```bash
make install
```

### 2. Create a Minimal Root Filesystem

2.1. Create directories for our root filesystem:
```bash
mkdir -p rootfs/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}
```

2.2. Copy BusyBox binaries to the root filesystem:
```bash
cp -a _install/* rootfs/
```

2.3. Create necessary device nodes:
```bash
sudo mknod rootfs/dev/console c 5 1
sudo mknod rootfs/dev/null c 1 3
```

2.4. Create an init script (rootfs/init):
```bash
cat > rootfs/init << EOF
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
echo -e "\nBoot took $(cut -d' ' -f1 /proc/uptime) seconds\n"
exec /bin/sh
EOF
```

2.5. Make the init script executable:
```bash
chmod +x rootfs/init
```

### 3. Create a Disk Image

3.1. Create an empty disk image:
```bash
dd if=/dev/zero of=disk.img bs=1M count=100
```

3.2. Format the disk image with an ext2 filesystem:
```bash
mkfs.ext2 -F disk.img
```

3.3. Mount the disk image and copy the root filesystem:
```bash
mkdir -p /mnt/rootfs
sudo mount -o loop disk.img /mnt/rootfs
sudo cp -a rootfs/* /mnt/rootfs/
sudo umount /mnt/rootfs
```

### 4. Download a Pre-built Kernel

4.1. Download a pre-built kernel (this example uses a kernel from the Arch Linux project):
```bash
wget https://archive.archlinux.org/packages/l/linux/linux-5.15.96.arch1-1-x86_64.pkg.tar.zst
```

4.2. Extract the kernel:
```bash
tar xf linux-5.15.96.arch1-1-x86_64.pkg.tar.zst usr/lib/modules/5.15.96-arch1-1/vmlinuz --strip-components=4
mv vmlinuz bzImage
```

### 5. Boot with QEMU

5.1. Boot your custom userspace:
```bash
qemu-system-x86_64 -kernel bzImage \
                   -hda disk.img \
                   -append "root=/dev/sda rw init=/init" \
                   -nographic
```

## Expected Outcome
After executing the QEMU command, you should see the kernel boot messages followed by a shell prompt. The system will be a minimal environment with BusyBox providing basic utilities.

## Challenges

1. Modify the init script to display a custom welcome message.
2. Add a custom application to your userspace and make it run at boot.
3. Configure and enable networking in your QEMU environment.

## Troubleshooting

- If you encounter permission issues, ensure you're using `sudo` where necessary.
- If the kernel fails to boot, try downloading a different pre-built kernel or check if it's compatible with the virtual hardware QEMU is emulating.

## Conclusion

This exercise demonstrates how to build a minimal Linux userspace using BusyBox, create a bootable disk image, and launch it with QEMU using a pre-built kernel. This process is valuable for understanding how Linux systems are constructed and can be particularly useful for embedded systems development and rapid prototyping of userspace environments.
