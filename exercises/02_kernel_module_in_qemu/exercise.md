# QEMU Exercise for Kernel Developers

## Exercise: Implementing and Testing a Simple Character Device Driver

### Objective
Implement a simple character device driver that creates a device file `/dev/qemu_exercise`. When read from, it should return the string "Hello from QEMU!". When written to, it should print the written content to the kernel log. Test this driver using QEMU.

### Steps

* Implement the kernel module
* Create a QEMU disk image with the necessary development tools
* Boot a kernel in QEMU with the module
* Test the module functionality
* Use QEMU features to analyze the module behavior

### Implementation

#### Step 1: Implement the kernel module

Create a file named `qemu_exercise.c` with the following content:

```c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/uaccess.h>

#define DEVICE_NAME "qemu_exercise"
#define CLASS_NAME  "qemu"

static int major_number;
static struct class* qemu_exercise_class = NULL;
static struct device* qemu_exercise_device = NULL;

static char message[256] = "Hello from QEMU!";
static short size_of_message;

// Prototype functions
static int dev_open(struct inode *, struct file *);
static int dev_release(struct inode *, struct file *);
static ssize_t dev_read(struct file *, char *, size_t, loff_t *);
static ssize_t dev_write(struct file *, const char *, size_t, loff_t *);

static struct file_operations fops = {
    .open = dev_open,
    .read = dev_read,
    .write = dev_write,
    .release = dev_release,
};

static int __init qemu_exercise_init(void) {
    printk(KERN_INFO "QEMU Exercise: Initializing the module\n");

    major_number = register_chrdev(0, DEVICE_NAME, &fops);
    if (major_number < 0) {
        printk(KERN_ALERT "QEMU Exercise failed to register a major number\n");
        return major_number;
    }

    qemu_exercise_class = class_create(THIS_MODULE, CLASS_NAME);
    if (IS_ERR(qemu_exercise_class)) {
        unregister_chrdev(major_number, DEVICE_NAME);
        printk(KERN_ALERT "Failed to register device class\n");
        return PTR_ERR(qemu_exercise_class);
    }

    qemu_exercise_device = device_create(qemu_exercise_class, NULL, MKDEV(major_number, 0), NULL, DEVICE_NAME);
    if (IS_ERR(qemu_exercise_device)) {
        class_destroy(qemu_exercise_class);
        unregister_chrdev(major_number, DEVICE_NAME);
        printk(KERN_ALERT "Failed to create the device\n");
        return PTR_ERR(qemu_exercise_device);
    }

    printk(KERN_INFO "QEMU Exercise: device class created correctly\n");
    return 0;
}

static void __exit qemu_exercise_exit(void) {
    device_destroy(qemu_exercise_class, MKDEV(major_number, 0));
    class_unregister(qemu_exercise_class);
    class_destroy(qemu_exercise_class);
    unregister_chrdev(major_number, DEVICE_NAME);
    printk(KERN_INFO "QEMU Exercise: Goodbye from the LKM!\n");
}

static int dev_open(struct inode *inodep, struct file *filep) {
    printk(KERN_INFO "QEMU Exercise: Device has been opened\n");
    return 0;
}

static ssize_t dev_read(struct file *filep, char *buffer, size_t len, loff_t *offset) {
    int error_count = 0;
    error_count = copy_to_user(buffer, message, size_of_message);
    if (error_count == 0) {
        printk(KERN_INFO "QEMU Exercise: Sent %d characters to the user\n", size_of_message);
        return (size_of_message = 0);
    } else {
        printk(KERN_INFO "QEMU Exercise: Failed to send %d characters to the user\n", error_count);
        return -EFAULT;
    }
}

static ssize_t dev_write(struct file *filep, const char *buffer, size_t len, loff_t *offset) {
    sprintf(message, "%.*s", (int)min(len, sizeof(message) - 1), buffer);
    size_of_message = strlen(message);
    printk(KERN_INFO "QEMU Exercise: Received %zu characters from the user\n", len);
    return len;
}

static int dev_release(struct inode *inodep, struct file *filep) {
    printk(KERN_INFO "QEMU Exercise: Device successfully closed\n");
    return 0;
}

module_init(qemu_exercise_init);
module_exit(qemu_exercise_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Your Name");
MODULE_DESCRIPTION("A simple Linux char driver for QEMU exercise");
MODULE_VERSION("0.1");
```

Create a `Makefile` in the same directory:

```makefile
obj-m += qemu_exercise.o

all:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```

#### Step 2: Create a QEMU disk image

* Create a disk image:

```shell
qemu-img create -f qcow2 qemu_exercise.qcow2 10G
```

* Install a minimal Linux distribution (e.g., Debian) on the image using QEMU.

* Boot the image and install necessary tools:

```shell
apt-get update
apt-get install build-essential linux-headers-$(uname -r)
```

* Copy the module source and Makefile to the guest system.

#### Step 3: Boot the kernel in QEMU

Boot QEMU with the following command:

```shell
qemu-system-x86_64 -hda qemu_exercise.qcow2 -m 2G -enable-kvm -kernel /boot/vmlinuz-$(uname -r) -append "root=/dev/sda1 console=ttyS0" -nographic
```

#### Step 4: Test the module functionality

In the QEMU guest:

1. Build the module:

```shell
make
```

1. Load the module:

```shell
sudo insmod qemu_exercise.ko
```

1. Test reading from the device:

```shell
cat /dev/qemu_exercise
```

1. Test writing to the device:

```shell
echo "Test message" > /dev/qemu_exercise
```

1. Check kernel logs:

```shell
dmesg | tail
```

#### Step 5: Use QEMU features to analyze the module behavior

1. Use QEMU's GDB stub for debugging:
   Add `-s -S` to the QEMU command line, then connect with GDB and set breakpoints in the module functions.

1. Use QEMU tracing:
   Add `-trace events=/tmp/events.txt` to the QEMU command line, with an events file containing:

```shell
kvm_exit
kvm_entry
```

   This will help you analyze VM exits related to your module operations.

### Solution

If implemented correctly, you should see the following results:

1. When you run `cat /dev/qemu_exercise`, it should output:

```shell
Hello from QEMU!
```

1. When you run `echo "Test message" > /dev/qemu_exercise`, you should see in the kernel log (via `dmesg | tail`):

```text
QEMU Exercise: Received 12 characters from the user
```

1. The kernel log should also show messages for device open and close operations.

1. When using GDB, you should be able to set breakpoints in your module functions and step through the code.

1. The QEMU trace output should show VM exits corresponding to your module's I/O operations.

This exercise demonstrates implementing a basic kernel module, testing it with QEMU, and using QEMU's advanced features for debugging and analysis.
