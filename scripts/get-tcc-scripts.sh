#!/bin/sh 

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# get-tcc-scripts.sh gets all the scripts which will be used to
# compile tinycore's sources.
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

echo "Enter ip address of an http host with /tcc/"
read ip_address
echo "Is this IP good? $ip_address (y/n)"
read continue_y_n
if [ ! $continue_y_n = "y" ]; then
  exit 1
else
  echo "Continuing with the script."
fi

export ADDITIONAL_FILES_BASE_URL="http://$ip_address/tcc/"

mkdir -pv /home/tc/tcc

cd /home/tc/tcc
wget $ADDITIONAL_FILES_BASE_URL/common.sh
wget $ADDITIONAL_FILES_BASE_URL/prepare-compilation.sh
wget $ADDITIONAL_FILES_BASE_URL/tce-load-tinycore-sources.sh
wget $ADDITIONAL_FILES_BASE_URL/extract-tinycore-sources.sh
wget $ADDITIONAL_FILES_BASE_URL/patch-tinycore-sources.sh
wget $ADDITIONAL_FILES_BASE_URL/compile-tinycore-sources-within-host.sh
wget $ADDITIONAL_FILES_BASE_URL/prepare-chroot-part1.sh
wget $ADDITIONAL_FILES_BASE_URL/prepare-chroot-part2.sh
wget $ADDITIONAL_FILES_BASE_URL/compile-tinycore-sources-within-chroot-part1.sh
wget $ADDITIONAL_FILES_BASE_URL/compile-tinycore-sources-within-chroot-part2.sh
wget $ADDITIONAL_FILES_BASE_URL/compile-busybox.sh
wget $ADDITIONAL_FILES_BASE_URL/prepare-additional-modifications.sh
wget $ADDITIONAL_FILES_BASE_URL/reenter-chroot-part1.sh
wget $ADDITIONAL_FILES_BASE_URL/reenter-chroot-part2.sh
wget $ADDITIONAL_FILES_BASE_URL/apply-additional-modifications.sh

chmod +x tce-load-tinycore-sources.sh
chmod +x prepare-compilation.sh
chmod +x extract-tinycore-sources.sh
chmod +x patch-tinycore-sources.sh
chmod +x compile-tinycore-sources-within-host.sh
chmod +x prepare-chroot-part1.sh
chmod +x prepare-chroot-part2.sh
chmod +x compile-tinycore-sources-within-chroot-part1.sh
chmod +x compile-tinycore-sources-within-chroot-part2.sh
chmod +x compile-busybox.sh
chmod +x prepare-additional-modifications.sh
chmod +x reenter-chroot-part1.sh
chmod +x reenter-chroot-part2.sh
chmod +x apply-additional-modifications.sh

echo "The next script to run is prepare-compilation.sh. Do you want to run it now? (y/n)"
read continue_y_n
if [ $continue_y_n = "y" ]; then
  /home/tc/tcc/prepare-compilation.sh
fi
