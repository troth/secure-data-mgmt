#!/bin/bash
#
# Script to mount the encrypted loopback image.
#

. ./sec-data-cfg.sh

set -x

mkdir -p ${MNT_PT}

LOOP=$(losetup --find --show ${IMG})
cryptsetup luksOpen ${LOOP} ${IMG}  || exit 1
mount /dev/mapper/${IMG} ${MNT_PT}  || exit 1
