#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# This should be run after 
# compile-tinycore-sources-within-chroot-part1.sh
# compile-tinycore-sources-within-chroot-part2.sh and
# compile-busybox.sh because vi is needed and busybox has it.
#
# Another way is to run this in the host environment where the
# host busybox with vi is. After, reenter-chroot-part1.sh and
# reenter-chroot-part2.sh can be called to reenter chroot and
# then call apply-additional-modifications.sh.
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

echo "TC=$TC ok? (y/n)"
read continue_y_n
if [ ! $continue_y_n = "y" ]; then
  echo "Enter path"
  read TC
fi
echo "TC=$TC"
echo "TC=$TC ok? (y/n)"
read continue_y_n
if [ ! $continue_y_n = "y" ]; then
  exit 1
fi

. "$(dirname "$0")/common.sh"

echo "---"
echo "$ADDITIONAL_FILES_BASE_URL"
echo "$ENABLE_KERNEL"
echo "$MARCH"
echo "$MTUNE"
echo "$AUTOCONF_PACKAGE_NAME"
echo "$AUTOMAKE_PACKAGE_NAME"
echo "$BASH_PACKAGE_NAME"
echo "$BC_PACKAGE_NAME"
echo "$BINUTILS_PACKAGE_NAME"
echo "$BISON_PACKAGE_NAME"
echo "$BUSYBOX_PACKAGE_NAME"
echo "$BZIP2_PACKAGE_NAME"
echo "$COREUTILS_PACKAGE_NAME"
echo "$DIFFUTILS_PACKAGE_NAME"
echo "$E2FSPROGS_PACKAGE_NAME"
echo "$EXPAT_PACKAGE_NAME"
echo "$FILE_PACKAGE_NAME"
echo "$FINDUTILS_PACKAGE_NAME"
echo "$FLEX_PACKAGE_NAME"
echo "$GAWK_PACKAGE_NAME"
echo "$GCC_PACKAGE_NAME"
echo "$GETTEXT_PACKAGE_NAME"
echo "$GLIBC_PACKAGE_NAME"
echo "$GMP_PACKAGE_NAME"
echo "$GPERF_PACKAGE_NAME"
echo "$GREP_PACKAGE_NAME"
echo "$GROFF_PACKAGE_NAME"
echo "$GZIP_PACKAGE_NAME"
echo "$INTLTOOL_PACKAGE_NAME"
echo "$ISL_PACKAGE_NAME"
echo "$LIBTOOL_PACKAGE_NAME"
echo "$LIBXCRYPT_PACKAGE_NAME"
echo "$LINUX_PACKAGE_NAME"
echo "$M4_PACKAGE_NAME"
echo "$MAKE_PACKAGE_NAME"
echo "$MPC_PACKAGE_NAME"
echo "$MPFR_PACKAGE_NAME"
echo "$NCURSES_PACKAGE_NAME"
echo "$PATCH_PACKAGE_NAME"
echo "$PERL_PACKAGE_NAME"
echo "$PKG_CONFIG_PACKAGE_NAME"
echo "$PYTHON_PACKAGE_NAME"
echo "$READLINE_PACKAGE_NAME"
echo "$SED_PACKAGE_NAME"
echo "$TAR_PACKAGE_NAME"
echo "$TEXINFO_PACKAGE_NAME"
echo "$UTIL_LINUX_PACKAGE_NAME"
echo "$XML_PARSER_PACKAGE_NAME"
echo "$XZ_PACKAGE_NAME"
echo "$ZLIB_PACKAGE_NAME"
echo "$ZSTD_PACKAGE_NAME"
echo "---"
echo "Are the lines between --- displaying the right values? (y/n)"
read continue_y_n
if [ ! $continue_y_n = "y" ]; then
  exit 1
else
  echo "Continuing with the script."
fi

cd $TC/sources
echo "[remove binutils from /usr]"
cp $BINUTILS_PACKAGE_NAME-4.candidates.files $BINUTILS_PACKAGE_NAME-4.candidates.files.before-manual-edit
vi $BINUTILS_PACKAGE_NAME-4.candidates.files
mv $BINUTILS_PACKAGE_NAME-4.candidates.files binutils_usr.tce.list

cp $GCC_PACKAGE_NAME-5.candidates.files $GCC_PACKAGE_NAME-5.candidates.files.before-manual-edit
vi $GCC_PACKAGE_NAME-5.candidates.files
mv $GCC_PACKAGE_NAME-5.candidates.files gcc_usr_local_remove.tce.list

cp $NCURSES_PACKAGE_NAME-2.candidates.files $NCURSES_PACKAGE_NAME-2.candidates.files.before-manual-edit
vi $NCURSES_PACKAGE_NAME-2.candidates.files
mv $NCURSES_PACKAGE_NAME-2.candidates.files ncurses_usr_remove.tce.list

cp $BISON_PACKAGE_NAME-2.candidates.files $BISON_PACKAGE_NAME-2.candidates.files.before-manual-edit
vi $BISON_PACKAGE_NAME-2.candidates.files
mv $BISON_PACKAGE_NAME-2.candidates.files bison_usr_remove.tce.list

cp $GREP_PACKAGE_NAME-2.candidates.files $GREP_PACKAGE_NAME-2.candidates.files.before-manual-edit
vi $GREP_PACKAGE_NAME-2.candidates.files
mv $GREP_PACKAGE_NAME-2.candidates.files grep_usr_bin_remove.tce.list

# In $FINDUTILS_PACKAGE_NAME-2 compile step, there was this:
echo "edit /usr/local/bin/updatedb"
echo "/usr/local/bin/sort -> /usr/bin/sort"
# since it's not possible to use vi in the chroot environemnt at that point, I moved this here.
# this is to be executed in the host environment.
if [ ! -f $TC/sources/updatedb.patch ]; then
  echo "enter key to continue..."
  read continue_key_used_to_pause_only_no_check_not_used_after
  echo "starting vi"
  cp $TC/usr/local/bin/updatedb $TC/usr/local/bin/updatedb-original
  vi $TC/usr/local/bin/updatedb
  diff -u $TC/usr/local/bin/updatedb-original $TC/usr/local/bin/updatedb >> $TC/sources/updatedb.patch
  cat $TC/usr/local/bin/updatedb
  cat $TC/sources/updatedb.patch
  echo "enter key to continue..."
  read continue_key_used_to_pause_only_no_check_not_used_after
else
  echo "$TC/sources/updatedb.patch already exists."
  cat $TC/sources/updatedb.patch
fi

# In $GROFF_PACKAGE_NAME compile step, there was this:
echo "edit /usr/bin/texi2any"
echo "#! /usr/local/bin/perl"
# since it's not possible to use vi in the chroot environemnt at that point, I moved this here.
# this is to be executed in the host environment.
if [ ! -f $TC/sources/texi2any.patch ]; then
  less $TC/usr/bin/texi2any
  read continue_key_used_to_pause_only_no_check_not_used_after
  cp $TC/usr/bin/texi2any $TC/usr/bin/texi2any-original
  vi $TC/usr/bin/texi2any
  diff -u $TC/usr/bin/texi2any-original $TC/usr/bin/texi2any > $TC/sources/texi2any.patch
  echo "texi2any.patch written. Content:"
  cat $TC/sources/texi2any.patch
  less $TC/usr/bin/texi2any
  echo "enter key to continue"
  read continue_key_used_to_pause_only_no_check_not_used_after
else
  echo "$TC/sources/texi2any.patch already exists."
  cat $TC/sources/texi2any.patch
fi
