#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Before compiling tinycore sources, some of them need patches.
# Apply them using this script.
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

. "$(dirname "$0")/common.sh"

echo "---"
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

cd $GLIBC_PACKAGE_NAME-1
# fhs-1.patch comes from https://www.linuxfromscratch.org/lfs/view/12.2/chapter08/glibc.html
patch -Np1 -i ../$GLIBC_PACKAGE_NAME-fhs-1.patch
# linic - I replaced the following 2 comments from compile_tc16_x86 with a patch
# # edit manual/libc.tcexinfo
# remove @documentencoding UTF-8
# this first patch command applies to glibc-x.y-1
patch -Np1 -i ../$GLIBC_PACKAGE_NAME-manual-libc.texinfo.patch
cd ..
cd $GLIBC_PACKAGE_NAME-2
patch -Np1 -i ../$GLIBC_PACKAGE_NAME-fhs-1.patch
# linic - programmatically doing the following 2 lines
# edit Makeconfig
# remove -g -O
# linic - I also remove -g -O2
# linic - order of these sed commands is important. Always run the -O2 one first!
# if ran in reverse order, you may get this
# "gcc: error: 2: linked input file not found: No such file or directory"
# because 2 gets left as the value of the default_cflags
sed -i 's/default_cflags := *-g *-O2 */default_cflags :=/' Makeconfig
sed -i 's/default_cflags := *-g *-O */default_cflags :=/' Makeconfig
patch -Np1 -i ../$GLIBC_PACKAGE_NAME-manual-libc.texinfo.patch
cd ..


cd $GAWK_PACKAGE_NAME-1
sed -i 's/extras//' Makefile.in
cd ..

cd $BINUTILS_PACKAGE_NAME-2
sed '6009s/$add_dir//' -i ltmain.sh
cd ..

cd $BINUTILS_PACKAGE_NAME-3
patch -Np1 -i ../$BINUTILS_PACKAGE_NAME-upstream_fix-1.patch
cd ..

cd $BINUTILS_PACKAGE_NAME-4
patch -Np1 -i ../$BINUTILS_PACKAGE_NAME-upstream_fix-1.patch
cd ..

cd $GCC_PACKAGE_NAME-3
sed '/thread_header =/s/@.*@/gthr-posix.h/' -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in
cd ..

cd $BZIP2_PACKAGE_NAME
patch -Np1 -i ../$BZIP2_PACKAGE_NAME-install_docs-1.patch
echo "Patching Makefile using sed - part 1"
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
# Edit Makefile
# CC=gcc -march=i486 -mtune=i686 -Os -pipe
# CFLAGS=-Wall -Winline $(BIGFILES)
echo "Patching Makefile using sed - part 2"
sed -i "s/^CC=gcc\$/CC=gcc -march=${MARCH} -mtune=${MTUNE} -Os -pipe/" Makefile
sed -i 's/\(CFLAGS=.*\)-O2 -g\(.*\)/\1\2/' Makefile
# Edit Makefile-libbz2_so
# CC=gcc -march=i486 -mtune=i686 -Os -pipe
# CFLAGS=-fpic -fPIC -Wall -Winline $(BIGFILES)
echo "Patching Makefile-libbz2_so using sed"
sed -i "s/^CC=gcc\$/CC=gcc -march=${MARCH} -mtune=${MTUNE} -Os -pipe/" Makefile-libbz2_so
sed -i 's/\(CFLAGS=.*\)-O2 -g\(.*\)/\1\2/' Makefile-libbz2_so
cd ..

# edit configure
# TERMLIB_VARIANTS="tinfo ncursesw curses termlib termcap terminfo"
# #include <ncursesw/termcap.h
cd $TEXINFO_PACKAGE_NAME-2
patch -Np1 -i ../$TEXINFO_PACKAGE_NAME-configure.patch
cd ..

# linic - this is for $GROFF_PACKAGE_NAME, but I don't have texi2any, I'll have to modify it manually.
# edit /usr/bin/texi2any
# #! /usr/local/bin/perl

