#!/bin/bash
#
# Script to mount the encrypted loopback image.
#

. ./sec-data-cfg.sh

set -x

mkdir -p ${MNT_PT}

losetup ${LOOP} ${IMG}
cryptsetup luksOpen ${LOOP} ${IMG}
mount /dev/mapper/${IMG} ${MNT_PT}
