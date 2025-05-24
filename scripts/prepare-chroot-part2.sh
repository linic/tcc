#!/bin/bash

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# chroot environment preparation part 2. 
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

. "$(dirname "$0")/common.sh"

# Continuing the preparation of the chroot environment.
if grep -Fxq "chroot-prepartion-part2-success" compile_sequence_history.txt; then
  echo "chroot-prepartion-part2 skipped"
else
  echo "chroot-prepartion-part2-started" | tee -a compile_sequence_history.txt

  echo "----"

  mkdir -pv /boot
  mkdir -pv /home
  mkdir -pv /mnt
  mkdir -pv /opt
  mkdir -pv /srv

  mkdir -pv /etc/opt
  mkdir -pv /etc/sysconfig

  mkdir -pv /lib/firmware

  mkdir -pv /media/floppy
  mkdir -pv /media/cdrom

  mkdir -pv /usr/bin
  mkdir -pv /usr/include
  mkdir -pv /usr/lib
  mkdir -pv /usr/sbin
  mkdir -pv /usr/src
  mkdir -pv /usr/local/bin
  mkdir -pv /usr/local/include
  mkdir -pv /usr/local/lib
  mkdir -pv /usr/local/sbin
  mkdir -pv /usr/local/src

  mkdir -pv /usr/share/color
  mkdir -pv /usr/share/dict
  mkdir -pv /usr/share/doc
  mkdir -pv /usr/share/info
  mkdir -pv /usr/share/locale
  mkdir -pv /usr/share/man
  mkdir -pv /usr/local/share/color
  mkdir -pv /usr/local/share/dict
  mkdir -pv /usr/local/share/doc
  mkdir -pv /usr/local/share/info
  mkdir -pv /usr/local/share/locale
  mkdir -pv /usr/local/share/man

  mkdir -pv /usr/share/misc
  mkdir -pv /usr/share/terminfo
  mkdir -pv /usr/share/zoneinfo
  mkdir -pv /usr/local/share/misc
  mkdir -pv /usr/local/share/terminfo
  mkdir -pv /usr/local/share/zoneinfo

  mkdir -pv /usr/share/man/man1
  mkdir -pv /usr/share/man/man2
  mkdir -pv /usr/share/man/man3
  mkdir -pv /usr/share/man/man4
  mkdir -pv /usr/share/man/man5
  mkdir -pv /usr/share/man/man6
  mkdir -pv /usr/share/man/man7
  mkdir -pv /usr/share/man/man8
  mkdir -pv /usr/local/share/man/man1
  mkdir -pv /usr/local/share/man/man2
  mkdir -pv /usr/local/share/man/man3
  mkdir -pv /usr/local/share/man/man4
  mkdir -pv /usr/local/share/man/man5
  mkdir -pv /usr/local/share/man/man6
  mkdir -pv /usr/local/share/man/man7
  mkdir -pv /usr/local/share/man/man8

  mkdir -pv /var/cache
  mkdir -pv /var/local
  mkdir -pv /var/log
  mkdir -pv /var/mail
  mkdir -pv /var/opt
  mkdir -pv /var/spool

  mkdir -pv /var/lib/color
  mkdir -pv /var/lib/misc
  mkdir -pv /var/lib/locate

  ln -sfv /run /var/run
  ln -sfv /run/lock /var/lock
  ln -sfv /usr/bin/bash /bin/bash
  ln -sfv /usr/bin/bash /bin/sh

  install -dv -m 0750 /root
  install -dv -m 1777 /tmp /var/tmp

  ln -sv /proc/self/mounts /etc/mtab

  echo "chroot-prepartion-part2-success" >> /sources/compile_sequence_history.txt
fi

# linic - it seems fine to always rewrite /etc/hosts
cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF

# linic - Start a new process. The script ends here. If there is anything after this, it won't execute.
echo "You'll get a new command prompt. Run /tcc/compile-tinycore-sources-within-chroot-part1.sh"
exec /usr/bin/bash --login

