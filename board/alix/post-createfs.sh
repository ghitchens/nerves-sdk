#!/bin/sh

set -e

TARGETDIR=$1

NERVES_ROOT=$TARGETDIR/../../..
FWUP_CONFIG=$NERVES_ROOT/board/alix/fwup.conf
BASE_FW_NAME=nerves-alix-base

# Make sure that the size matches fwup.conf
BOOTSIZE=31232
BOOTPART=$NERVES_ROOT/buildroot/output/images/bootpart.bin
SYSLINUX=$NERVES_ROOT/buildroot/output/host/usr/bin/syslinux

$NERVES_ROOT/board/nerves-common/mksyslinuxfs.sh $NERVES_ROOT $BOOTPART $BOOTSIZE $SYSLINUX

# Run the common post-image processing for nerves
$NERVES_ROOT/board/nerves-common/post-createfs.sh $TARGETDIR $FWUP_CONFIG $BASE_FW_NAME

