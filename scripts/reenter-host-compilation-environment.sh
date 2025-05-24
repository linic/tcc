#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# This is taken from prepare-compilation.sh, but only mounts
# the partition and enters the shell.
# This is to be run when reentering the shell used to compile with
# the host in case, the tinycore machine was shut down.
# The compilation process is long so you might want to do some of
# it one day and some more another day.
###################################################################

export TC=/mnt/tc

sudo mkdir -pv  $TC

echo "Going forward, lots of stuff will be written to /dev/sdb1. Do you want to proceed? (y/n)"
read continue_y_n
if [ $continue_y_n = "y" ]; then
  echo "Continuing with the script."
else
  echo "Exiting script."
  exit 0
fi

# Mount only if not already mounted.
if ! grep -qs "$TC" /proc/mounts; then
  # linic - if /dev/sdb1 is not the right partition on your machine, select another. This should
  # be an empty ext4 partition.
  sudo mount /dev/sdb1 $TC
fi

# linic - nothing will be executed after this line because a new terminal with new environment variables will open.
source ~/.bash_profile
