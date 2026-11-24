# TOFIX

Findings from a code scan on 2026-10-04.

## High

- `exercises/05_system_from_scratch/build.sh:62` - `cp ../../../init_scripts/init /sbin/init` writes to the host's absolute `/sbin/init` instead of the initrd staging tree (cwd is `_install`); as a normal user the build fails, as root it overwrites the host's init. Use `cp ../../../init_scripts/init sbin/init`.

## Medium

- `exercises/01_boot_cloud_image_different_arch/clean.sh:3` - removes `QEMU_EFI.fd`, which is a tracked file in this folder, and leaves the generated `cloud-init.iso` behind (so a later `build.sh` reuses a stale ISO); remove `cloud-init.iso` instead of `QEMU_EFI.fd`.
- `exercises/00_boot_cloud_image_same_arch/ssh.sh:2` - logs in as `ubuntu@localhost`, but this exercise boots a Debian cloud image (`build.sh:5`) whose default user is `debian`, as `exercise.md:66` says; use `debian@localhost`.
- `exercises/05_system_from_scratch/run.sh:25` - the x86_64 branch boots with `rdinit=/init`, but `build.sh:62` installs the init script as `/sbin/init` and busybox's `_install` has no `/init`; use `rdinit=/sbin/init` like the arm branch (line 15).
- `exercises/05_system_from_scratch/host_prepare.sh:6` - the kernel version is hardcoded to `6.2.0-1005-lowlatency` (the `uname -r` line is commented out), so the `cp /boot/vmlinuz-...` fails on any other machine; restore `KERNEL_VERSION=$(uname -r)`.
- `exercises/06_qemu_cpu_info/qemu_cpu_info.py:49` - `parse_cpu_list` expects lines starting with `x86`/`arm`, but current QEMU prints `Available CPUs:` followed by indented names; running it reports `Supported CPU types (0)` for x86_64 and only the 7 `arm*` CPUs for aarch64 (verified). Parse the indented lines after the header.
- `exercises/08_device_tree_overlay/Makefile:11` - `apply` calls `dtoverlay ... -o final.dtb`; `dtoverlay` is the Raspberry Pi runtime loader and has no output-file mode. Use `fdtoverlay -i basic.dtb -o final.dtb uart-gps.dtbo`, and build `basic.dtb` with `dtc -@` (line 5) so `&uart0` in `overlay.dts:14` can be resolved.

## Low

- `exercises/05_system_from_scratch/host_run.sh:10` - `-append` is passed twice (again at line 13); QEMU keeps only the last, so `root=/dev/ram` is silently dropped. Merge into one `-append "root=/dev/ram console=ttyS0"`.
- `exercises/05_system_from_scratch/host_arm.sh:6` - boots `build/zImage` and `build/initrd.cpio.gz`, which nothing in the exercise produces (`build.sh` writes them under `build/linux-*/arch/arm/boot/` and `build/busybox-*/`); point it at the real paths from `defs.sh` or delete it.
- `exercises/05_system_from_scratch/check_all_ok.sh:35` - `$$USER` prints the shell PID followed by `USER` (e.g. `12345USER`); use `${USER}` (same at line 43).
- `exercises/01_boot_cloud_image_different_arch/id_vm:1` - `id_vm` holds an RSA *public* key and does not match `id_vm.pub` (an ed25519 key), and no key is installed through `user-data`, so `ssh.sh:2`'s `-i ./id_vm` cannot work; drop both files and the `-i` option, or generate a real pair and add `ssh_authorized_keys` to `user-data`.
- `exercises/01_boot_cloud_image_different_arch/notes.md:15` - says the VM uses `-bios QEMU_EFI.fd`, but `boot.sh:7` uses `/usr/share/qemu-efi-aarch64/QEMU_EFI.fd` and the committed `QEMU_EFI.fd` binary is unused; use the local copy or remove it and fix the note.
- `exercises/00_boot_cloud_image_same_arch/build.sh:5` - downloads Debian 11 (bullseye), which is past end of life; move to a supported release (and update `exercise.md:19`).
