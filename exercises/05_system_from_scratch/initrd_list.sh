#!/bin/bash -e

# shellcheck source=/dev/null
source defs.sh

gunzip --stdout "${INITRD_FULL_PATH}" | cpio --list
