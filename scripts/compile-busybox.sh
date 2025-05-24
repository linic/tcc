#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Compile busybox after all other TC sources have been compiled.
# Compile it within the chroot environment used for compilation
# of the other sources.
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

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

cd /sources
if grep -Fxq "$BUSYBOX_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$BUSYBOX_PACKAGE_NAME skipped."
else
  echo "$BUSYBOX_PACKAGE_NAME-started" >> compile_sequence_history.txt
  cd $BUSYBOX_PACKAGE_NAME
  patch -Np1 -i ../busybox-1.27.1-wget-make-default-timeout-configurable.patch
  patch -Np1 -i ../busybox-1.29.3_root_path.patch
  patch -Np1 -i ../busybox-1.33.0_modprobe.patch
  patch -Np0 -i ../busybox-1.33.0_tc_depmod.patch

  # First compilation with suid
  cp ../${BUSYBOX_PACKAGE_NAME}_config_suid .config
  make oldconfig
  make CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti"
  mkdir -pv /tmp/pkg
  touch $BUSYBOX_PACKAGE_NAME-suid-time-marker
  make CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" CONFIG_PREFIX=/tmp/pkg install
  touch $BUSYBOX_PACKAGE_NAME-suid.candidates.files
  find / -not -type 'd' -cnewer $BUSYBOX_PACKAGE_NAME-suid-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $BUSYBOX_PACKAGE_NAME-suid.candidates.files
  mv /tmp/pkg/bin/busybox /tmp/pkg/bin/busybox.suid
  echo "Making your busybox binary setuid root"
  chmod u+s /tmp/pkg/bin/busybox.suid

  # Second compilation with nosuid
  cp ../${BUSYBOX_PACKAGE_NAME}_config_nosuid .config
  make oldconfig
  make CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti"
  touch $BUSYBOX_PACKAGE_NAME-nosuid-time-marker
  make CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" CONFIG_PREFIX=/tmp/pkg install
  touch $BUSYBOX_PACKAGE_NAME-nosuid.candidates.files
  find / -not -type 'd' -cnewer $BUSYBOX_PACKAGE_NAME-nosuid-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $BUSYBOX_PACKAGE_NAME-nosuid.candidates.files
  echo "$BUSYBOX_PACKAGE_NAME-success" >> /sources/compile_sequence_history.txt
fi
# Making busybox ends here

echo "The next script would be prepare-additional-modifications.sh. You need vi for it. There are 2 files named busybox-*suid.candidates.files. Those should contain the path to busybox. Then, start a shell with ./busybox sh"
