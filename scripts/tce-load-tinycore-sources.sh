#!/bin/sh 

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Load the .tcz extensions required by
# compile-tinycore-sources-*.sh
# compile-busybox.sh
###################################################################

# From http://tinycorelinux.net/16.x/x86/release/src/toolchain/compile_tc16_x86
tce-load -w compiletc perl5 ncursesw-dev bash mpc-dev udev-dev texinfo coreutils glibc_apps gettext python3.9 curl
tce-load -i compiletc perl5 ncursesw-dev bash mpc-dev udev-dev texinfo coreutils glibc_apps gettext python3.9 curl
# From http://tinycorelinux.net/15.x/x86/release/src/busybox/compile_busybox
tce-load -w compiletc sstrip
tce-load -i compiletc sstrip

