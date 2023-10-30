#!/bin/bash -e

source defs.sh

cat "${INITRD_FULL_PATH}" | cpio --list
