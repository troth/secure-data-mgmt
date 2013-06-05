#!/bin/bash
#
# Script to setup an encrypted loopback image.
#

. ./sec-data-cfg.sh

set -x

dd if=/dev/urandom of=${IMG} bs=1M count=${SIZE_MB}
losetup /dev/loop1 ${IMG}
cryptsetup luksFormat -c "aes-xts-essiv:sha256" -s 512 -y ${LOOP}
cryptsetup luksOpen ${LOOP} ${IMG}
mkfs.ext3 /dev/mapper/${IMG}
sync
cryptsetup luksClose ${IMG}
sync
losetup -d ${LOOP}
