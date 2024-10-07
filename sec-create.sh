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

CIPHER=(
    # --cipher

    # This the default and recommended cipher.
    # aes-xts-plain64

    # This is what I have used in the past (used to be recommended).
    # aes-xts-essiv:sha256
    # -s 512
)

set -x

dd if=/dev/urandom of=${IMG} bs=1M count=${SIZE_MB} || exit 1

LOOP=$(losetup --find --show ${IMG})
test -n "${LOOP}" && {
    cryptsetup --type luks2 luksFormat "${CIPHER[@]}" -y ${LOOP} && {
        cryptsetup luksOpen ${LOOP} ${IMG} && {
            mkfs.ext4 /dev/mapper/${IMG}
            sync
            cryptsetup luksClose ${IMG}
            sync
        }
    }
    losetup -d ${LOOP}
}
