#!/bin/bash -e

source defs.sh

find build -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;
