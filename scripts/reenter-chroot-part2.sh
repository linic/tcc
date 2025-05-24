#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Run this after reenter-chroot.sh.
# The reason for this is that reenter-chroot.sh does a login after
# which nothing can be run.
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

# linic - Start a new process. The script ends here. If there is anything after this, it won't execute.
exec /usr/bin/bash --login
