#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# chroot environment preparation part 1. 
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

. "$(dirname "$0")/common.sh"

export TC=/mnt/tc

cd $TC/sources

# Making some copies and chroot
# The following note came later in the original compile_tc16_x86, but it was too late at that point to copy those since chroot had changed the root.
if grep -Fxq "copy-passwd-group-nsswitch.conf-ld.so.conf-success" compile_sequence_history.txt; then
  echo "copy-passwd-group-nsswitch.conf-ld.so.conf skipped."
else
  echo "copy-passwd-group-nsswitch.conf-ld.so.conf-started" | tee -a compile_sequence_history.txt
  echo "[copy tc /etc/passwd and /etc/group files to $TC/etc]"
  # linic - added the next 2 lines
  sudo cp -v /etc/passwd $TC/etc/
  sudo cp -v /etc/group $TC/etc/
  # Search for nsswitch.conf and you'll find the original comment.
  echo "[copy tc /etc/nsswitch.conf and /etc/ld.so.conf files to $TC/etc]"
  # linic - added the next 2 lines
  sudo cp -v /etc/nsswitch.conf $TC/etc/
  sudo cp -v /etc/ld.so.conf $TC/etc/
  echo "copy-passwd-group-nsswitch.conf-ld.so.conf-success" | tee -a compile_sequence_history.txt
fi

if grep -Fxq "chroot-prepartion-part1-success" compile_sequence_history.txt; then
  echo "chroot-prepartion-part1 skipped"
else
  # Preparing the isolated chroot environment part 1
  echo "chroot-prepartion-part1-started" | tee -a compile_sequence_history.txt
  sudo chown -R root:root $TC/usr
  sudo chown -R root:root $TC/lib
  sudo chown -R root:root $TC/var
  sudo chown -R root:root $TC/etc
  sudo chown -R root:root $TC/bin
  sudo chown -R root:root $TC/sbin
  sudo chown -R root:root $TC/tools

  sudo mkdir -pv $TC/dev
  sudo mkdir -pv $TC/proc
  sudo mkdir -pv $TC/sys
  sudo mkdir -pv $TC/run

  sudo mount -v --bind /dev $TC/dev

  sudo mount -vt devpts devpts -o gid=5,mode=0620 $TC/dev/pts
  sudo mount -vt proc proc $TC/proc
  sudo mount -vt sysfs sysfs $TC/sys
  sudo mount -vt tmpfs tmpfs $TC/run
  echo "chroot-prepartion-part1-success" | tee -a compile_sequence_history.txt
fi

# linic - this interrupts the script. Nothing after it gets executed
echo "You'll have a new command prompt. Run prepare-chroot-part2.sh"
sudo /usr/local/sbin/chroot "$TC" /usr/bin/env -i HOME=/root TERM="$TERM" PS1='(tc chroot) \u:\w\$ ' PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin /usr/bin/bash --login

