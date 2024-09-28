#!/bin/bash
#
# Script to setup an encrypted loopback image.
#

. ./sec-data-cfg.sh

set -x

if [ -f "${IMG}" ]
then
    # Don't wnat to clobber an existing file.
    echo "ERROR: Image file already exists: ${IMG}"
    exit 1
fi

dd if=/dev/urandom of=${IMG} bs=1M count=${SIZE_MB} || exit 1

LOOP=$(losetup --find --show ${IMG})
test -z "${LOOP}" && exit 1

cryptsetup luksFormat -c "aes-xts-essiv:sha256" -s 512 -y ${LOOP} || exit 1
cryptsetup luksOpen ${LOOP} ${IMG} || exit 1
mkfs.ext4 /dev/mapper/${IMG} || exit 1
sync
cryptsetup luksClose ${IMG}
sync
losetup -d ${LOOP}
