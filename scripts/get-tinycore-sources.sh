#!/bin/sh 

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Get all the sources required by
# compile-tinycore-sources-*.sh
# compile-busybox.sh
# and place them in a tcc directory.
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

# I thought I would use rsync to get the files in x86/release/src/toolchain, but too many are missing.
# I'm hunting the original source of these files and downloading them from the source.
# tce-load -wi rsync.tcz
# rsync -dtivhrlH  --delete rsync.ibiblio.org::tinycorelinux/$TCL_VERSION/x86/release/src/toolchain/ .

# Choose where to get the sources which usually come from ftp-gnu-org
# FTP_GNU_ORG=ftp-gnu-org
FTP_GNU_ORG=mirror2.evolution-host.com

# TODO - replace all $FTP_GNU_ORG with mirror2.evolution-host.com which is much faster at my place
# or have a variable.
curl --remote-name https://$FTP_GNU_ORG/gnu/binutils/$BINUTILS_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/gcc/$GCC_PACKAGE_NAME/$GCC_PACKAGE_NAME.tar.xz
curl --remote-name https://git.kernel.org/pub/scm/linux/kernel/git/cip/linux-cip.git/snapshot/$LINUX_PACKAGE_NAME.tar.gz
curl --remote-name https://$FTP_GNU_ORG/gnu/glibc/$GLIBC_PACKAGE_NAME.tar.xz
curl --remote-name http://lfs.linux-sysadmin.com/patches/downloads/glibc/$GLIBC_PACKAGE_NAME-fhs-1.patch
# More info about m4 https://lists.gnu.org/archive/html/info-gnu/2021-05/msg00014.html
# and https://www.gnu.org/software/m4/manual/m4.html
curl --remote-name https://$FTP_GNU_ORG/gnu/m4/$M4_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/gmp/$GMP_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/mpc/$MPC_PACKAGE_NAME.tar.gz
curl --remote-name https://$FTP_GNU_ORG/gnu/mpfr/$MPFR_PACKAGE_NAME.tar.xz
curl --remote-name https://invisible-island.net/archives/ncurses/$NCURSES_PACKAGE_NAME.tar.gz
curl --remote-name https://$FTP_GNU_ORG/gnu/bash/$BASH_PACKAGE_NAME.tar.gz
curl --remote-name https://$FTP_GNU_ORG/gnu/coreutils/$COREUTILS_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/diffutils/$DIFFUTILS_PACKAGE_NAME.tar.xz
# Code source seems to come from here https://www.darwinsys.com/file/
# I found the tar on fossies https://fossies.org/linux/misc/$FILE_PACKAGE_NAME.tar.gz/ there's no original download link for the .tar.gz.
# I could get the source code from ftp://ftp.astron.com/pub/file/, but I would need to test more.
# for now, I validated the sha512sum of the tar at fossies is the same than the tar at http://tinycorelinux.net/16.x/x86/release/src/toolchain/$FILE_PACKAGE_NAME.tar.gz
curl --remote-name https://fossies.org/linux/misc/$FILE_PACKAGE_NAME.tar.gz
curl --remote-name https://$FTP_GNU_ORG/gnu/findutils/$FINDUTILS_PACKAGE_NAME.tar.xz
# https://lists.gnu.org/archive/html/info-gnu/2024-09/msg00008.html
curl --remote-name https://$FTP_GNU_ORG/gnu/gawk/$GAWK_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/grep/$GREP_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/gzip/$GZIP_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/make/$MAKE_PACKAGE_NAME.tar.gz
curl --remote-name https://$FTP_GNU_ORG/gnu/patch/$PATCH_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/sed/$SED_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/tar/$TAR_PACKAGE_NAME.tar.xz
curl --location --remote-name https://github.com/tukaani-project/xz/releases/download/v5.6.3/$XZ_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/binutils/$BINUTILS_PACKAGE_NAME.tar.xz
curl --remote-name http://tinycorelinux.net/16.x/x86/release/src/toolchain/uname_hack.so
curl --remote-name https://$FTP_GNU_ORG/gnu/gettext/$GETTEXT_PACKAGE_NAME.tar.xz
# Perl's official website refers to metacpan: https://dev.perl.org/perl5/news/
# [5.40.0 needs a locale set]
curl --remote-name https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/$PERL_PACKAGE_NAME.tar.gz
curl --remote-name https://www.python.org/ftp/python/3.13.0/$PYTHON_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/texinfo/$TEXINFO_PACKAGE_NAME.tar.xz
curl --remote-name https://www.kernel.org/pub/linux/utils/util-linux/v2.40/$UTIL_LINUX_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/bison/$BISON_PACKAGE_NAME.tar.xz
curl --remote-name https://zlib.net/$ZLIB_PACKAGE_NAME.tar.xz
# linic - this is very similar to this https://www.linuxfromscratch.org/lfs/view/9.1-systemd/chapter06/bzip2.html
# linic - going forward, when I need a patch from lfs (linuxfromscratch) look here http://lfs.linux-sysadmin.com/patches/downloads/
curl --remote-name http://lfs.linux-sysadmin.com/patches/downloads/bzip2/$BZIP2_PACKAGE_NAME-install_docs-1.patch
curl --remote-name https://sourceware.org/pub/bzip2/$BZIP2_PACKAGE_NAME.tar.gz
curl --location --remote-name https://github.com/facebook/zstd/releases/download/v1.5.6/$ZSTD_PACKAGE_NAME.tar.gz
curl --remote-name https://$FTP_GNU_ORG/gnu/readline/$READLINE_PACKAGE_NAME.tar.gz
curl --location --remote-name https://github.com/gavinhoward/bc/releases/download/7.0.3/$BC_PACKAGE_NAME.tar.xz
curl --location --remote-name https://github.com/westes/flex/releases/download/v2.6.4/$FLEX_PACKAGE_NAME.tar.gz
curl --location --remote-name http://pkgconfig.freedesktop.org/releases/$PKG_CONFIG_PACKAGE_NAME.tar.gz
curl --remote-name http://lfs.linux-sysadmin.com/patches/downloads/binutils/$BINUTILS_PACKAGE_NAME-upstream_fix-1.patch
curl --remote-name https://gcc.gnu.org/pub/gcc/infrastructure/$ISL_PACKAGE_NAME.tar.bz2
curl --location --remote-name https://github.com/besser82/libxcrypt/releases/download/v4.4.36/$LIBXCRYPT_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/libtool/$LIBTOOL_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/gperf/$GPERF_PACKAGE_NAME.tar.gz
curl --location --remote-name https://github.com/libexpat/libexpat/releases/download/R_2_6_4/$EXPAT_PACKAGE_NAME.tar.xz
curl --remote-name https://cpan.metacpan.org/authors/id/T/TO/TODDR/$XML_PARSER_PACKAGE_NAME.tar.gz
curl --location --remote-name https://launchpad.net/intltool/trunk/0.51.0/+download/$INTLTOOL_PACKAGE_NAME.tar.gz
curl --remote-name https://$FTP_GNU_ORG/gnu/autoconf/$AUTOCONF_PACKAGE_NAME.tar.xz
curl --remote-name https://$FTP_GNU_ORG/gnu/automake/$AUTOMAKE_PACKAGE_NAME.tar.xz
curl --remote-name http://lfs.linux-sysadmin.com/patches/downloads/coreutils/$COREUTILS_PACKAGE_NAME-i18n-2.patch
curl --remote-name https://$FTP_GNU_ORG/gnu/groff/$GROFF_PACKAGE_NAME.tar.gz
curl --location --remote-name https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.1/$E2FSPROGS_PACKAGE_NAME.tar.gz
wget http://tinycorelinux.net/15.x/x86/release/src/busybox/busybox-1.27.1-wget-make-default-timeout-configurable.patch
wget http://tinycorelinux.net/15.x/x86/release/src/busybox/busybox-1.29.3_root_path.patch
wget http://tinycorelinux.net/15.x/x86/release/src/busybox/busybox-1.33.0_modprobe.patch
wget http://tinycorelinux.net/15.x/x86/release/src/busybox/busybox-1.33.0_tc_depmod.patch
wget http://tinycorelinux.net/15.x/x86/release/src/busybox/${BUSYBOX_PACKAGE_NAME}_config_nosuid
wget http://tinycorelinux.net/15.x/x86/release/src/busybox/${BUSYBOX_PACKAGE_NAME}_config_suid
curl --remote-name https://busybox.net/downloads/$BUSYBOX_PACKAGE_NAME.tar.bz2

wget $ADDITIONAL_FILES_BASE_URL/.bashrc
wget $ADDITIONAL_FILES_BASE_URL/.bash_profile
wget $ADDITIONAL_FILES_BASE_URL/$GAWK_PACKAGE_NAME-Makefile.in.patch
wget $ADDITIONAL_FILES_BASE_URL/$GLIBC_PACKAGE_NAME-manual-libc.texinfo.patch
wget $ADDITIONAL_FILES_BASE_URL/$TEXINFO_PACKAGE_NAME-configure.patch
wget $ADDITIONAL_FILES_BASE_URL/.config-v4.x
