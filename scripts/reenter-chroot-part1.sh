#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Run this if you got out of the chroot midway to troubleshoot
# something and you want to get back in it to continue the
# compilation.
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

echo "linic - you're logging in, you'll have a new shell. Run reenter-chroot-part2.sh"
sudo /usr/local/sbin/chroot "$TC" /usr/bin/env -i HOME=/root TERM="$TERM" PS1='(tc chroot) \u:\w\$ ' PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin /usr/bin/bash --login
