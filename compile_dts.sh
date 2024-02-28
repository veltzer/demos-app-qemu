#!/bin/bash -ex

OVERLAY="versatile-elbit.dts"
BASE="versatile_full.dts"
MY_DTS="merged.dts"
# MY_DTB="versatile-elbit.dtb"
dtc -I dts -O dts -o "${MY_DTS}" "${OVERLAY}" "${BASE}"
