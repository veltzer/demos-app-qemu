# Build ARM embedded system from scratch

* install a cross compiler from the ubuntu apt repository
    `gcc-arm-linux-gnueabi`

* install qemu from the ubuntu apt repository
    `qemu-system-arm`

* download the linux kernel source code from [here](http://www.kernel.org).
    download version 6.7.4

* configure the kernel using the provided configuration callled

```bash
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- versatile_defconfig
```

* compile the kernel with the cross compiler downloaded in (1):

```bash
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-
```

* download busybox latest version.

* configure busybox with the default configuration called:

```bash
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- defconfig
```

* compile busy box using the cross compiler:

```bash
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-
```

* install busy by issuing:

```bash
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- install
```

* Add salt and pepper (including an init script).

* package everything with `cpio(1)`:

```bash
cd _install
find . -print0 | cpio --null --verbose --create --format=newc | gzip -9 > initrd.cpio.gz
```

* run everything with `qemu-system-arm` and the right paramters:

```bash
	qemu-system-${ARCH}\
		-machine "${QEMU_MACHINE_TYPE}"\
		-kernel "${KERNEL_IMAGE}"\
		-audio driver=none,model=hda\
		-nographic\
		-dtb "build/${KERNEL_BUILD_FOLDER}/arch/arm/boot/dts/arm/versatile-pb.dtb"\
		-initrd "${INITRD_FULL_PATH}"\
		-append "rdinit=/init"
```
