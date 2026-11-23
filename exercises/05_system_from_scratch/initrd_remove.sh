#!/bin/bash -e

# shellcheck source=/dev/null
source defs.sh
: "${INITRD_FULL_PATH:?INITRD_FULL_PATH must be set}"

rm "${INITRD_FULL_PATH}"
