# QEMU Exercise: Booting a Cloud-Based Image

## Objective
Set up and boot a cloud-based Linux image using QEMU, preparing it for kernel development work.

## Prerequisites
- QEMU installed on your system
- Basic familiarity with command-line operations

## Exercise Steps

### 1. Download a Cloud Image

Download a Debian cloud image:

```bash
wget https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2
```

### 2. Prepare the Image

Rename and resize the image:

```bash
mv debian-11-generic-amd64.qcow2 dev_environment.qcow2
qemu-img resize dev_environment.qcow2 +5G
```

### 3. Create a Cloud-Init Configuration

Create a file named `cloud-init.txt` with the following content:

```yaml
#cloud-config
password: mypassword
chpasswd: { expire: False }
ssh_pwauth: True
```

### 4. Generate Cloud-Init ISO

Install cloud-image-utils and create the ISO:

```bash
sudo apt-get install cloud-image-utils
cloud-localds cloud-init.iso cloud-init.txt
```

### 5. Boot the Image with QEMU

Start QEMU with the following command:

```bash
qemu-system-x86_64 \
  -hda dev_environment.qcow2 \
  -cdrom cloud-init.iso \
  -m 2G \
  -nographic \
  -enable-kvm \
  -net nic -net user,hostfwd=tcp::2222-:22
```

### 6. Log In and Verify

- Once the system boots, log in with username `debian` and password `mypassword`.
- Verify the system is working correctly:

```bash
uname -a
df -h
```

### 7. Update and Install Development Tools

Update the system and install necessary packages:

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential linux-headers-$(uname -r)
```

### 8. Shutdown the VM

When you're done, shut down the VM:

```bash
sudo shutdown -h now
```

## Challenges

1. Modify the cloud-init configuration to set a different hostname for the VM.
2. Use QEMU's snapshot feature to create a snapshot of your VM after installing development tools.
3. Set up port forwarding to allow SSH access to the VM from your host machine.

## Solution

Here's what you should expect:

1. After running the QEMU command, you should see boot messages followed by a login prompt.
2. Logging in with `debian` and `mypassword` should give you a command prompt.
3. `uname -a` should show information about the Debian system and kernel.
4. `df -h` should show the increased disk space (around 15GB total).
5. After updating and installing packages, you should be able to compile kernel modules.

If you completed the challenges:
1. Your VM should have the custom hostname you set.
2. You should be able to list and revert to your snapshot using QEMU commands.
3. You should be able to SSH into your VM using `ssh -p 2222 debian@localhost`.

## Conclusion

This exercise demonstrates how to quickly set up a development environment using QEMU and cloud images. This approach is particularly useful for kernel developers who need to test their code on clean, reproducible systems.

## Hints
* To get out of qemu while running in `-nographic` mode: `CTRL+A+C` and then `quit`.
* Your username on a debian system is `debian`.
