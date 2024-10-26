#!/bin/bash -e

source defs.sh

gunzip --stdout "${INITRD_FULL_PATH}" | cpio --list
