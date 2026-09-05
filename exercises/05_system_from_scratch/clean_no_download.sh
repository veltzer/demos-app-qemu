#!/bin/bash -e

# shellcheck source=/dev/null
source defs.sh

find build -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;
