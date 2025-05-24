#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# This is to prepare the compilation before
# compile-tinycore-sources-within-host.sh is called.
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

export TC=/mnt/tc

sudo mkdir -pv $TC

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

sudo mkdir -pv $TC/usr
sudo mkdir -pv $TC/lib
sudo mkdir -pv $TC/var
sudo mkdir -pv $TC/etc
sudo mkdir -pv $TC/bin
sudo mkdir -pv $TC/sbin

sudo chown -v tc:staff $TC/usr
sudo chown -v tc:staff $TC/lib
sudo chown -v tc:staff $TC/var
sudo chown -v tc:staff $TC/etc
sudo chown -v tc:staff $TC/bin
sudo chown -v tc:staff $TC/sbin

sudo mkdir -pv $TC/tools
sudo chown tc:staff $TC/tools

if [ ! -L /tools ]; then
  sudo ln -s $TC/tools /
fi

if [ -d /home/tc/tcc ]; then
  sudo mkdir -pv $TC/tcc
  sudo chown tc:staff $TC/tcc
  mv -v /home/tc/tcc/* $TC/tcc/
  rmdir /home/tc/tcc
fi

sudo mkdir -p $TC/sources
sudo chown tc:staff $TC/sources
# linic - if the sources were pre-downloaded and pre-extracted somewhere else, change this line.
if [ -d /home/tc/sources ]; then
  mv -v /home/tc/sources/* $TC/sources/
  mv -v /home/tc/sources/.bash* $TC/sources/
  mv -v /home/tc/sources/.config* $TC/sources/
  rmdir /home/tc/sources
fi
cd $TC/sources
$TC/tcc/tce-load-tinycore-sources.sh
$TC/tcc/get-tinycore-sources.sh
$TC/tcc/extract-tinycore-sources.sh
$TC/tcc/patch-tinycore-sources.sh

# linic - cat > ~/.bash_profile << "EOF" was replaced with a .bash_profile
# linic - cat > ~/.bashrc << "EOF" was replaced with a .bashrc
# linic - both should have been obtained by get-tinycore-sources.sh

cp $TC/sources/.bashrc ~/.bashrc
cp $TC/sources/.bash_profile ~/.bash_profile

cd $TC/sources
touch compile_sequence_history.txt

# linic - nothing will be executed after this line because a new terminal with new environment variables will open.
echo "source ~/.bash_profile is next. You'll get a command prompt. Continue with copmile-tinycore-sources-within-host.sh"
source ~/.bash_profile
