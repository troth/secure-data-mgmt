#!/bin/bash
#
# Script to unmount encrypted data loopback image.
#

. sec-data-cfg.sh

set -x

umount ${MNT_PT}
cryptsetup luksClose ${IMG}
losetup -d ${LOOP}
