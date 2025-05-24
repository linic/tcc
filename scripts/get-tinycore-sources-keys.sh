#!/bin/sh 

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Get all the sources signing KEYS which would then be used before
# compiling. The script is incomplete. For use later maybe...
###################################################################

. "$(dirname "$0")/common.sh"

# Eventually, I would like to validate the files I'm downloading with the .sig or .asc which
# is often present (but not always). For now, I'm downloading the signatures, but not using them.
# The gpgme extension dates back to 2013 - http://tinycorelinux.net/16.x/x86/tcz/gpgme.tcz.info. I wonder if it works with today's keys.
# if it doesn't work, it would have to be regenerated https://www.gnupg.org/
# getting the gnu-keyring.gpg to verify most of the downloads below.
curl --remote-name https://ftp.gnu.org/gnu/gnu-keyring.gpg
# gpg --import gnu-keyring.gpg
curl --remote-name https://ftp.gnu.org/gnu/binutils/$BINUTILS_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/gcc/$GCC_PACKAGE_NAME/$GCC_PACKAGE_NAME.tar.xz.sig
# keys are here https://wiki.linuxfoundation.org/civilinfrastructureplatform/cipkernelmaintenance
curl --remote-name https://git.kernel.org/pub/scm/docs/kernel/pgpkeys.git/tree/keys/36A3BADB36B27332.asc
curl --remote-name https://git.kernel.org/pub/scm/linux/kernel/git/cip/linux-cip.git/snapshot/$LINUX_PACKAGE_NAME.tar.asc
curl --remote-name https://ftp.gnu.org/gnu/glibc/$GLIBC_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/m4/$M4_PACKAGE_NAME.tar.xz.sig
# Public keys for ncurses are here https://invisible-island.net/public/public.html
curl --remote-name https://invisible-island.net/public/dickey@invisible-island.net-rsa3072.asc
curl --remote-name https://invisible-island.net/archives/ncurses/$NCURSES_PACKAGE_NAME.tar.gz.asc
curl --remote-name https://ftp.gnu.org/gnu/bash/$BASH_PACKAGE_NAME.tar.gz.sig
curl --remote-name https://ftp.gnu.org/gnu/coreutils/$COREUTILS_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/diffutils/$DIFFUTILS_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/findutils/$FINDUTILS_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/gawk/$GAWK_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/grep/$GREP_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/gzip/$GZIP_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/make/$MAKE_PACKAGE_NAME.tar.gz.sig
curl --remote-name https://ftp.gnu.org/gnu/patch/$PATCH_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/sed/$SED_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/tar/$TAR_PACKAGE_NAME.tar.xz.sig
# PGP key for sig validation https://tukaani.org/contact.html
curl --remote-name https://tukaani.org/misc/lasse_collin_pubkey.txt
curl --location --remote-name https://github.com/tukaani-project/xz/releases/download/v5.6.3/$XZ_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/binutils/$BINUTILS_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://ftp.gnu.org/gnu/gettext/$GETTEXT_PACKAGE_NAME.tar.xz.sig
# https://www.gnu.org/prep/ftp.html
# Verifying the signatures https://www.gnupg.org/faq/gnupg-faq.html#how_do_i_verify_signed_packages
curl --remote-name https://ftp.gnu.org/gnu/bison/$BISON_PACKAGE_NAME.tar.xz.sig
# PGP keys for python are here https://www.python.org/downloads/metadata/pgp/
# Python is starting to drop the PGP signatures with 3.14.0: https://peps.python.org/pep-0761/
curl --remote-name https://www.python.org/ftp/python/3.13.0/$PYTHON_PACKAGE_NAME.tar.xz.asc
curl --remote-name https://ftp.gnu.org/gnu/texinfo/$TEXINFO_PACKAGE_NAME.tar.xz.sig
curl --remote-name https://www.kernel.org/pub/linux/utils/util-linux/v2.40/$UTIL_LINUX_PACKAGE_NAME.tar.sign
curl --remote-name https://zlib.net/$ZLIB_PACKAGE_NAME.tar.xz.asc
curl --remote-name https://sourceware.org/pub/bzip2/$BZIP2_PACKAGE_NAME.tar.gz.sig
curl --location --remote-name https://github.com/facebook/zstd/releases/download/v1.5.6/$ZSTD_PACKAGE_NAME.tar.gz.sig
curl --remote-name https://ftp.gnu.org/gnu/readline/$READLINE_PACKAGE_NAME.tar.gz.sig
curl --remote-name https://pkg-config.freedesktop.org/releases/pkg-config-0.29.tar.gz.asc
curl --location --remote-name https://github.com/besser82/libxcrypt/releases/download/v4.4.36/$LIBXCRYPT_PACKAGE_NAME.tar.xz.asc
