# QEMU Exercise: Building and Booting a Custom BusyBox Userspace

## Objective
Build a minimal Linux userspace environment using BusyBox, create a disk image, and boot it using QEMU.

## Prerequisites
- Linux development environment
- QEMU installed
- Basic knowledge of Linux commands and build processes

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

### 3. Create a Dis