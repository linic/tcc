#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# This should be run after prepare-additional-modifications.sh.
# Read the comments in prepare-additional-modifications.sh before
# running this one!
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

cd /sources

for file in `cat binutils_usr.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done

for file in `cat gcc_usr_local_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done

for file in `cat ncurses_usr_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done

for file in `cat bison_usr_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done

for file in `cat grep_usr_bin_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done

cd /

echo "Do you want to run the updatedb.patch and texi2any.patch? You may have already done the modifications manually. (y/n)"
read continue_y_n
if [ $continue_y_n = "y" ]; then
  patch -Np2 -i /sources/updatedb.patch
  patch -Np2 -i /sources/texi2any.patch
fi

echo "At this point, all the sources needed should have been recompiled. compile_tc16_x86 ends with:"
echo "[remove files to match base/extension setup]"
echo "Possible way forward: unpack rootfs.gz and look at it with the tree command if available or find all files and list them in a file. Then, check what you want to replace and replace them manually. Maybe make a rootfs.tce.map which would list source path destination path on each line and could be processed with a script."
