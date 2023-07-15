#!/bin/bash
#
# Script to unmount encrypted data loopback image.
#

. sec-data-cfg.sh

set -x

umount ${MNT_PT}
cryptsetup luksClose ${IMG}

LOOP=$(losetup --list | awk -v img="${IMG}" '/img/ {print $1}')
losetup -d ${LOOP}
