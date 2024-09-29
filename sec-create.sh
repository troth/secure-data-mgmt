#!/bin/bash
#
# Script to setup an encrypted loopback image.
#

. ./sec-data-cfg.sh

if [ -f "${IMG}" ]
then
    # Don't wnat to clobber an existing file.
    echo "ERROR: Image file already exists: ${IMG}"
    exit 1
fi

set -x

dd if=/dev/urandom of=${IMG} bs=1M count=${SIZE_MB} || exit 1

LOOP=$(losetup --find --show ${IMG})
test -n "${LOOP}" && {
    cryptsetup luksFormat -c "aes-xts-essiv:sha256" -s 512 -y ${LOOP} && {
        cryptsetup luksOpen ${LOOP} ${IMG} && {
            mkfs.ext4 /dev/mapper/${IMG}
            sync
            cryptsetup luksClose ${IMG}
            sync
        }
    }
    losetup -d ${LOOP}
}
