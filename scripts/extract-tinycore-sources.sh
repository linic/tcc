#!/bin/sh 

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Extract the sources required by
# compile-tinycore-sources-*.sh
# compile-busybox.sh
# When extracting more than 1 time and tar-name-# appears, that
# source will be built more than once; sometimes with different
# patches or configure settings.
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

if [ ! -d $BINUTILS_PACKAGE_NAME-1 ]; then
  tar x -f $BINUTILS_PACKAGE_NAME.tar.xz
  mv -v $BINUTILS_PACKAGE_NAME $BINUTILS_PACKAGE_NAME-1
fi
if [ ! -d $BINUTILS_PACKAGE_NAME-2 ]; then
  tar x -f $BINUTILS_PACKAGE_NAME.tar.xz
  mv -v $BINUTILS_PACKAGE_NAME $BINUTILS_PACKAGE_NAME-2
fi
if [ ! -d $BINUTILS_PACKAGE_NAME-3 ]; then
  tar x -f $BINUTILS_PACKAGE_NAME.tar.xz
  mv -v $BINUTILS_PACKAGE_NAME $BINUTILS_PACKAGE_NAME-3
fi
if [ ! -d $BINUTILS_PACKAGE_NAME-4 ]; then
  tar x -f $BINUTILS_PACKAGE_NAME.tar.xz
  mv -v $BINUTILS_PACKAGE_NAME $BINUTILS_PACKAGE_NAME-4
fi

if [ ! -d $GCC_PACKAGE_NAME-1 ]; then
  tar x -f $GCC_PACKAGE_NAME.tar.xz
  tar x -f $GMP_PACKAGE_NAME.tar.xz
  mv -v $GMP_PACKAGE_NAME $GCC_PACKAGE_NAME/gmp
  tar x -f $MPC_PACKAGE_NAME.tar.gz
  mv -v $MPC_PACKAGE_NAME $GCC_PACKAGE_NAME/mpc
  tar x -f $MPFR_PACKAGE_NAME.tar.xz
  mv -v $MPFR_PACKAGE_NAME $GCC_PACKAGE_NAME/mpfr

  mv -v $GCC_PACKAGE_NAME $GCC_PACKAGE_NAME-1
fi

if [ ! -d $GCC_PACKAGE_NAME-2 ]; then
  tar x -f $GCC_PACKAGE_NAME.tar.xz
  tar x -f $GMP_PACKAGE_NAME.tar.xz
  mv -v $GMP_PACKAGE_NAME $GCC_PACKAGE_NAME/gmp
  tar x -f $MPC_PACKAGE_NAME.tar.gz
  mv -v $MPC_PACKAGE_NAME $GCC_PACKAGE_NAME/mpc
  tar x -f $MPFR_PACKAGE_NAME.tar.xz
  mv -v $MPFR_PACKAGE_NAME $GCC_PACKAGE_NAME/mpfr

  mv -v $GCC_PACKAGE_NAME $GCC_PACKAGE_NAME-2
fi

if [ ! -d $GCC_PACKAGE_NAME-3 ]; then
  tar x -f $GCC_PACKAGE_NAME.tar.xz
  tar x -f $GMP_PACKAGE_NAME.tar.xz
  mv -v $GMP_PACKAGE_NAME $GCC_PACKAGE_NAME/gmp
  tar x -f $MPC_PACKAGE_NAME.tar.gz
  mv -v $MPC_PACKAGE_NAME $GCC_PACKAGE_NAME/mpc
  tar x -f $MPFR_PACKAGE_NAME.tar.xz
  mv -v $MPFR_PACKAGE_NAME $GCC_PACKAGE_NAME/mpfr

  mv -v $GCC_PACKAGE_NAME $GCC_PACKAGE_NAME-3
fi

if [ ! -d $GCC_PACKAGE_NAME-4 ]; then
  tar x -f $GCC_PACKAGE_NAME.tar.xz
  tar x -f $GMP_PACKAGE_NAME.tar.xz
  mv -v $GMP_PACKAGE_NAME $GCC_PACKAGE_NAME/gmp
  tar x -f $MPC_PACKAGE_NAME.tar.gz
  mv -v $MPC_PACKAGE_NAME $GCC_PACKAGE_NAME/mpc
  tar x -f $MPFR_PACKAGE_NAME.tar.xz
  mv -v $MPFR_PACKAGE_NAME $GCC_PACKAGE_NAME/mpfr

  mv -v $GCC_PACKAGE_NAME $GCC_PACKAGE_NAME-4
fi

if [ ! -d $GCC_PACKAGE_NAME-5 ]; then
  tar x -f $GCC_PACKAGE_NAME.tar.xz
  tar x -f $GMP_PACKAGE_NAME.tar.xz
  mv -v $GMP_PACKAGE_NAME $GCC_PACKAGE_NAME/gmp
  tar x -f $MPC_PACKAGE_NAME.tar.gz
  mv -v $MPC_PACKAGE_NAME $GCC_PACKAGE_NAME/mpc
  tar x -f $MPFR_PACKAGE_NAME.tar.xz
  mv -v $MPFR_PACKAGE_NAME $GCC_PACKAGE_NAME/mpfr

  mv -v $GCC_PACKAGE_NAME $GCC_PACKAGE_NAME-5
fi

if [ ! -d $GMP_PACKAGE_NAME ]; then
  tar x -f $GMP_PACKAGE_NAME.tar.xz
fi

if [ ! -d $MPC_PACKAGE_NAME ]; then
  tar x -f $MPC_PACKAGE_NAME.tar.gz
fi

if [ ! -d $MPFR_PACKAGE_NAME ]; then
  tar x -f $MPFR_PACKAGE_NAME.tar.xz
fi


if [ ! -d $LINUX_PACKAGE_NAME ]; then
  tar x -f $LINUX_PACKAGE_NAME.tar.gz
fi

if [ ! -d $GLIBC_PACKAGE_NAME-1 ]; then
  tar x -f $GLIBC_PACKAGE_NAME.tar.xz
  mv -v $GLIBC_PACKAGE_NAME $GLIBC_PACKAGE_NAME-1
fi
if [ ! -d $GLIBC_PACKAGE_NAME-2 ]; then
  tar x -f $GLIBC_PACKAGE_NAME.tar.xz
  mv -v $GLIBC_PACKAGE_NAME $GLIBC_PACKAGE_NAME-2
fi

if [ ! -d $M4_PACKAGE_NAME-1 ]; then
  tar x -f $M4_PACKAGE_NAME.tar.xz
  mv -v $M4_PACKAGE_NAME $M4_PACKAGE_NAME-1
fi
if [ ! -d $M4_PACKAGE_NAME-2 ]; then
  tar x -f $M4_PACKAGE_NAME.tar.xz
  mv -v $M4_PACKAGE_NAME $M4_PACKAGE_NAME-2
fi

# Found on https://fossies.org/
# The original home page is https://invisible-island.net/ncurses/
# The original index for all versions https://invisible-island.net/archives/ncurses/
if [ ! -d $NCURSES_PACKAGE_NAME-1 ]; then
  tar x -f $NCURSES_PACKAGE_NAME.tar.gz
  mv -v $NCURSES_PACKAGE_NAME $NCURSES_PACKAGE_NAME-1
fi
if [ ! -d $NCURSES_PACKAGE_NAME-2 ]; then
  tar x -f $NCURSES_PACKAGE_NAME.tar.gz
  mv -v $NCURSES_PACKAGE_NAME $NCURSES_PACKAGE_NAME-2
fi

if [ ! -d $BASH_PACKAGE_NAME-1 ]; then
  tar x -f $BASH_PACKAGE_NAME.tar.gz
  mv -v $BASH_PACKAGE_NAME $BASH_PACKAGE_NAME-1
fi
if [ ! -d $BASH_PACKAGE_NAME-2 ]; then
  tar x -f $BASH_PACKAGE_NAME.tar.gz
  mv -v $BASH_PACKAGE_NAME $BASH_PACKAGE_NAME-2
fi

if [ ! -d $COREUTILS_PACKAGE_NAME-1 ]; then
  tar x -f $COREUTILS_PACKAGE_NAME.tar.xz
  mv -v $COREUTILS_PACKAGE_NAME $COREUTILS_PACKAGE_NAME-1
fi
if [ ! -d $COREUTILS_PACKAGE_NAME-2 ]; then
  tar x -f $COREUTILS_PACKAGE_NAME.tar.xz
  mv -v $COREUTILS_PACKAGE_NAME $COREUTILS_PACKAGE_NAME-2
fi


# https://lists.gnu.org/archive/html/info-gnu/2023-05/msg00009.html
if [ ! -d $DIFFUTILS_PACKAGE_NAME-1 ]; then
  tar x -f $DIFFUTILS_PACKAGE_NAME.tar.xz
  mv -v $DIFFUTILS_PACKAGE_NAME $DIFFUTILS_PACKAGE_NAME-1
fi
if [ ! -d $DIFFUTILS_PACKAGE_NAME-2 ]; then
  tar x -f $DIFFUTILS_PACKAGE_NAME.tar.xz
  mv -v $DIFFUTILS_PACKAGE_NAME $DIFFUTILS_PACKAGE_NAME-2
fi

if [ ! -d $FILE_PACKAGE_NAME-1 ]; then
  tar x -f $FILE_PACKAGE_NAME.tar.gz
  mv -v $FILE_PACKAGE_NAME $FILE_PACKAGE_NAME-1
fi
if [ ! -d $FILE_PACKAGE_NAME-2 ]; then
  tar x -f $FILE_PACKAGE_NAME.tar.gz
  mv -v $FILE_PACKAGE_NAME $FILE_PACKAGE_NAME-2
fi

if [ ! -d $FINDUTILS_PACKAGE_NAME-1 ]; then
  tar x -f $FINDUTILS_PACKAGE_NAME.tar.xz
  mv -v $FINDUTILS_PACKAGE_NAME $FINDUTILS_PACKAGE_NAME-1
fi
if [ ! -d $FINDUTILS_PACKAGE_NAME-2 ]; then
  tar x -f $FINDUTILS_PACKAGE_NAME.tar.xz
  mv -v $FINDUTILS_PACKAGE_NAME $FINDUTILS_PACKAGE_NAME-2
fi

if [ ! -d $GAWK_PACKAGE_NAME-1 ]; then
  tar x -f $GAWK_PACKAGE_NAME.tar.xz
  mv -v $GAWK_PACKAGE_NAME $GAWK_PACKAGE_NAME-1
fi
if [ ! -d $GAWK_PACKAGE_NAME-2 ]; then
  tar x -f $GAWK_PACKAGE_NAME.tar.xz
  mv -v $GAWK_PACKAGE_NAME $GAWK_PACKAGE_NAME-2
fi

if [ ! -d $GREP_PACKAGE_NAME-1 ]; then
  tar x -f $GREP_PACKAGE_NAME.tar.xz
  mv -v $GREP_PACKAGE_NAME $GREP_PACKAGE_NAME-1
fi
if [ ! -d $GREP_PACKAGE_NAME-2 ]; then
  tar x -f $GREP_PACKAGE_NAME.tar.xz
  mv -v $GREP_PACKAGE_NAME $GREP_PACKAGE_NAME-2
fi

if [ ! -d $GZIP_PACKAGE_NAME-1 ]; then
  tar x -f $GZIP_PACKAGE_NAME.tar.xz
  mv -v $GZIP_PACKAGE_NAME $GZIP_PACKAGE_NAME-1
fi
if [ ! -d $GZIP_PACKAGE_NAME-2 ]; then
  tar x -f $GZIP_PACKAGE_NAME.tar.xz
  mv -v $GZIP_PACKAGE_NAME $GZIP_PACKAGE_NAME-2
fi

if [ ! -d $MAKE_PACKAGE_NAME-1 ]; then
  tar x -f $MAKE_PACKAGE_NAME.tar.gz
  mv -v $MAKE_PACKAGE_NAME $MAKE_PACKAGE_NAME-1
fi
if [ ! -d $MAKE_PACKAGE_NAME-2 ]; then
  tar x -f $MAKE_PACKAGE_NAME.tar.gz
  mv -v $MAKE_PACKAGE_NAME $MAKE_PACKAGE_NAME-2
fi

if [ ! -d $PATCH_PACKAGE_NAME-1 ]; then
  tar x -f $PATCH_PACKAGE_NAME.tar.xz
  mv -v $PATCH_PACKAGE_NAME $PATCH_PACKAGE_NAME-1
fi
if [ ! -d $PATCH_PACKAGE_NAME-2 ]; then
  tar x -f $PATCH_PACKAGE_NAME.tar.xz
  mv -v $PATCH_PACKAGE_NAME $PATCH_PACKAGE_NAME-2
fi

if [ ! -d $SED_PACKAGE_NAME-1 ]; then
  tar x -f $SED_PACKAGE_NAME.tar.xz
  mv -v $SED_PACKAGE_NAME $SED_PACKAGE_NAME-1
fi
if [ ! -d $SED_PACKAGE_NAME-2 ]; then
  tar x -f $SED_PACKAGE_NAME.tar.xz
  mv -v $SED_PACKAGE_NAME $SED_PACKAGE_NAME-2
fi

if [ ! -d $TAR_PACKAGE_NAME-1 ]; then
  tar x -f $TAR_PACKAGE_NAME.tar.xz
  mv -v $TAR_PACKAGE_NAME $TAR_PACKAGE_NAME-1
fi
if [ ! -d $TAR_PACKAGE_NAME-2 ]; then
  tar x -f $TAR_PACKAGE_NAME.tar.xz
  mv -v $TAR_PACKAGE_NAME $TAR_PACKAGE_NAME-2
fi

if [ ! -d $XZ_PACKAGE_NAME-1 ]; then
  tar x -f $XZ_PACKAGE_NAME.tar.xz
  mv -v $XZ_PACKAGE_NAME $XZ_PACKAGE_NAME-1
fi
if [ ! -d $XZ_PACKAGE_NAME-2 ]; then
  tar x -f $XZ_PACKAGE_NAME.tar.xz
  mv -v $XZ_PACKAGE_NAME $XZ_PACKAGE_NAME-2
fi

if [ ! -d $GETTEXT_PACKAGE_NAME-1 ]; then
  tar x -f $GETTEXT_PACKAGE_NAME.tar.xz
  mv -v $GETTEXT_PACKAGE_NAME $GETTEXT_PACKAGE_NAME-1
fi
if [ ! -d $GETTEXT_PACKAGE_NAME-2 ]; then
  tar x -f $GETTEXT_PACKAGE_NAME.tar.xz
  mv -v $GETTEXT_PACKAGE_NAME $GETTEXT_PACKAGE_NAME-2
fi

if [ ! -d $BISON_PACKAGE_NAME-1 ]; then
  tar x -f $BISON_PACKAGE_NAME.tar.xz
  mv -v $BISON_PACKAGE_NAME $BISON_PACKAGE_NAME-1
fi
if [ ! -d $BISON_PACKAGE_NAME-2 ]; then
  tar x -f $BISON_PACKAGE_NAME.tar.xz
  mv -v $BISON_PACKAGE_NAME $BISON_PACKAGE_NAME-2
fi


if [ ! -d $PERL_PACKAGE_NAME-1 ]; then
  tar x -f $PERL_PACKAGE_NAME.tar.gz
  mv -v $PERL_PACKAGE_NAME $PERL_PACKAGE_NAME-1
fi
if [ ! -d $PERL_PACKAGE_NAME-2 ]; then
  tar x -f $PERL_PACKAGE_NAME.tar.gz
  mv -v $PERL_PACKAGE_NAME $PERL_PACKAGE_NAME-2
fi


if [ ! -d $PYTHON_PACKAGE_NAME ]; then
  tar x -f $PYTHON_PACKAGE_NAME.tar.xz
fi

if [ ! -d $TEXINFO_PACKAGE_NAME-1 ]; then
  tar x -f $TEXINFO_PACKAGE_NAME.tar.xz
  mv -v $TEXINFO_PACKAGE_NAME $TEXINFO_PACKAGE_NAME-1
fi
if [ ! -d $TEXINFO_PACKAGE_NAME-2 ]; then
  tar x -f $TEXINFO_PACKAGE_NAME.tar.xz
  mv -v $TEXINFO_PACKAGE_NAME $TEXINFO_PACKAGE_NAME-2
fi


if [ ! -d $UTIL_LINUX_PACKAGE_NAME-1 ]; then
  tar x -f $UTIL_LINUX_PACKAGE_NAME.tar.xz
  mv -v $UTIL_LINUX_PACKAGE_NAME $UTIL_LINUX_PACKAGE_NAME-1
fi
if [ ! -d $UTIL_LINUX_PACKAGE_NAME-2 ]; then
  tar x -f $UTIL_LINUX_PACKAGE_NAME.tar.xz
  mv -v $UTIL_LINUX_PACKAGE_NAME $UTIL_LINUX_PACKAGE_NAME-2
fi
if [ ! -d $UTIL_LINUX_PACKAGE_NAME-3 ]; then
  tar x -f $UTIL_LINUX_PACKAGE_NAME.tar.xz
  mv -v $UTIL_LINUX_PACKAGE_NAME $UTIL_LINUX_PACKAGE_NAME-3
fi


if [ ! -d $BUSYBOX_PACKAGE_NAME ]; then
  if [ ! -f $BUSYBOX_PACKAGE_NAME.tar ]; then
    bzip2 --decompress --keep $BUSYBOX_PACKAGE_NAME.tar.bz2
  fi
  tar x -f $BUSYBOX_PACKAGE_NAME.tar
fi

if [ ! -d $ZLIB_PACKAGE_NAME ]; then
  tar x -f $ZLIB_PACKAGE_NAME.tar.xz
fi

if [ ! -d $BZIP2_PACKAGE_NAME ]; then
  tar x -f $BZIP2_PACKAGE_NAME.tar.gz
fi

if [ ! -d $ZSTD_PACKAGE_NAME ]; then
  tar x -f $ZSTD_PACKAGE_NAME.tar.gz
fi

if [ ! -d $READLINE_PACKAGE_NAME ]; then
  tar x -f $READLINE_PACKAGE_NAME.tar.gz
fi

# linic - I found out this LFS page which has the same dependencies: https://www.linuxfromscratch.org/lfs/view/development/chapter03/packages.html
if [ ! -d $BC_PACKAGE_NAME ]; then
  tar x -f $BC_PACKAGE_NAME.tar.xz
fi

if [ ! -d $FLEX_PACKAGE_NAME ]; then
  tar x -f $FLEX_PACKAGE_NAME.tar.gz
fi

if [ ! -d $PKG_CONFIG_PACKAGE_NAME ]; then
  tar x -f $PKG_CONFIG_PACKAGE_NAME.tar.gz
fi

if [ ! -d $ISL_PACKAGE_NAME ]; then
  tar x -f $ISL_PACKAGE_NAME.tar.bz2
fi

if [ ! -d $LIBXCRYPT_PACKAGE_NAME ]; then
  tar x -f $LIBXCRYPT_PACKAGE_NAME.tar.xz
fi

if [ ! -d $LIBTOOL_PACKAGE_NAME ]; then
  tar x -f $LIBTOOL_PACKAGE_NAME.tar.xz
fi

if [ ! -d $GPERF_PACKAGE_NAME ]; then
  tar x -f $GPERF_PACKAGE_NAME.tar.gz
fi

if [ ! -d $EXPAT_PACKAGE_NAME ]; then
  tar x -f $EXPAT_PACKAGE_NAME.tar.xz
fi

if [ ! -d $XML_PARSER_PACKAGE_NAME ]; then
  tar x -f $XML_PARSER_PACKAGE_NAME.tar.gz
fi

if [ ! -d $INTLTOOL_PACKAGE_NAME ]; then
  tar x -f $INTLTOOL_PACKAGE_NAME.tar.gz
fi

if [ ! -d $AUTOCONF_PACKAGE_NAME ]; then
  tar x -f $AUTOCONF_PACKAGE_NAME.tar.xz
fi

if [ ! -d $AUTOMAKE_PACKAGE_NAME ]; then
  tar x -f $AUTOMAKE_PACKAGE_NAME.tar.xz
fi

if [ ! -d $GROFF_PACKAGE_NAME ]; then
  tar x -f $GROFF_PACKAGE_NAME.tar.gz
fi
if [ ! -d $E2FSPROGS_PACKAGE_NAME-1 ]; then
  tar x -f $E2FSPROGS_PACKAGE_NAME.tar.gz
  mv -v $E2FSPROGS_PACKAGE_NAME $E2FSPROGS_PACKAGE_NAME-1
fi
if [ ! -d $E2FSPROGS_PACKAGE_NAME-2 ]; then
  tar x -f $E2FSPROGS_PACKAGE_NAME.tar.gz
  mv -v $E2FSPROGS_PACKAGE_NAME $E2FSPROGS_PACKAGE_NAME-2
fi

