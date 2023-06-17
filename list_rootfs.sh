#!/bin/bash -e

source defs.sh

cat "${ROOTFS_FULL_PATH}" | cpio --list
