#!/bin/bash
#
# Script for setting up a USB flash drive with an encrypted private partition
# and an unencrypted public partition.
#

if [ $(id -u) -ne 0 ]
then
    echo "Need to be root to run this script. Running sudo..."
    exec sudo "$0" "$@"
fi

function usage()
{
    echo "Usage: $0 /dev/<usb-disk> [<label-suffix>]"
    exit 1
}

DEV="${1}"
if [ -z "${DEV}" ]; then
    usage
fi

LABEL_SUFFIX="${2:-part}"

DEVMAP="sec-usb-setup"
MNTPT="/mnt"

LABEL_SEC="sec-${LABEL_SUFFIX}"
LABEL_PUB="pub-${LABEL_SUFFIX}"

cat <<EOF
###############################################################################
#
# LABELS: ${LABEL_SEC} ${LABEL_PUB}
#
# This script will reformat the '$DEV' device.
# Any data on that device will be lost!
#
###############################################################################
EOF
read -p "Do you really want to continue? (Type 'yes' in capital letters): " yn
case "${yn}" in
    YES)
        ;;
    *)
        echo "Aborted"
        exit 1
        ;;
esac

PARTED_ARGS=(
    unit MiB
    mklabel gpt
    mkpart "${LABEL_SEC}"  ext4 4     1004
    mkpart "${LABEL_PUB}"  ext4 1004  -1
    print
)
set -x

parted -s -- "${DEV}" "${PARTED_ARGS[@]}"
sync

wipefs -a "${DEV}1"
shred -v "${DEV}1"

cryptsetup luksFormat --type luks2 --pbkdf argon2id "${DEV}1" || exit 1
cryptsetup open --type luks2 "${DEV}1" ${DEVMAP} || exit 1
cryptsetup -v status ${DEVMAP}
mkfs -t ext4 -L "${LABEL_SEC}" /dev/mapper/${DEVMAP} && sync
cryptsetup close ${DEVMAP}
sync
cryptsetup config "${DEV}1" --label "${LABEL_SEC}"
sync

wipefs -a "${DEV}2"
mkfs -t ext4 -L "${LABEL_PUB}" "${DEV}2"
sync
