#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Compile TC sources within chroot part 2. 
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
if grep -Fxq "$BASH_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$BASH_PACKAGE_NAME-2 skipped."
else
  # linic - I wonder why the remove is here instead of when bulding grep just before. I kept the compile_tc16_x86 order.
  # linic - the grep_usr_bin_remove.tce.list is generated right after the make install for grep.
  echo "[remove grep from /usr/bin]"
  for file in `cat grep_usr_bin_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done
  echo "$BASH_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making libtool. 1st time!
cd /sources
if grep -Fxq "$LIBTOOL_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$LIBTOOL_PACKAGE_NAME skipped."
else
  echo "$LIBTOOL_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $LIBTOOL_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --disable-static
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  rm -fv /usr/local/lib/libltdl.a
  echo "$LIBTOOL_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making gperf. 1st time!
cd /sources
if grep -Fxq "$GPERF_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$GPERF_PACKAGE_NAME skipped."
else
  echo "$GPERF_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $GPERF_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --docdir=/usr/local/share/doc/$GPERF_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name config.status -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$GPERF_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making expat. 1st time!
cd /sources
if grep -Fxq "$EXPAT_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$EXPAT_PACKAGE_NAME skipped."
else
  echo "$EXPAT_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $EXPAT_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --disable-static --docdir=/usr/local/share/doc/$EXPAT_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ldconfig
  echo "$EXPAT_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making perl again.
cd /sources
if grep -Fxq "$PERL_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$PERL_PACKAGE_NAME-2 skipped."
else
  echo "$PERL_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $PERL_PACKAGE_NAME-2
  export BUILD_ZLIB=False
  export BUILD_BZIP2=0
  LD_PRELOAD=/sources/uname_hack.so sh Configure -des -Dcc="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" -Dprefix=/usr/local -Dvendorprefix=/usr/local -Dprivlib=/usr/local/lib/perl5/5.32/core_perl -Darchlib=/usr/local/lib/perl5/5.32/core_perl -Dsitelib=/usr/local/lib/perl5/5.32/site_perl -Dsitearch=/usr/local/lib/perl5/5.32/site_perl -Dvendorlib=/usr/local/lib/perl5/5.32/vendor_perl -Dvendorarch=/usr/local/lib/perl5/5.32/vendor_perl -Dman1dir=/usr/local/share/man/man1 -Dman3dir=/usr/local/share/man/man3 -Dpager="/usr/bin/less -isR" -Duseshrplib -Dusethreads
  find . -name Makefile -type f -exec sed -i 's/-O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  unset BUILD_ZLIB BUILD_BZIP2
  rm /usr/bin/perl
  echo "$PERL_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making $XML_PARSER_PACKAGE_NAME. 1st time.
cd /sources
if grep -Fxq "$XML_PARSER_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$XML_PARSER_PACKAGE_NAME skipped."
else
  echo "$XML_PARSER_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $XML_PARSER_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so perl Makefile.PL
  find . -name Makefile -type f -exec sed -i 's/-O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$XML_PARSER_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making intltool. 1st time!
cd /sources
if grep -Fxq "$INTLTOOL_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$INTLTOOL_PACKAGE_NAME skipped."
else
  echo "$INTLTOOL_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $INTLTOOL_PACKAGE_NAME
  sed -i 's:\\\${:\\\$\\{:' intltool-update.in
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$INTLTOOL_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making autoconf. 1st time!
cd /sources
if grep -Fxq "$AUTOCONF_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$AUTOCONF_PACKAGE_NAME skipped."
else
  echo "$AUTOCONF_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $AUTOCONF_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$AUTOCONF_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making automake. 1st time!
cd /sources
if grep -Fxq "$AUTOMAKE_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$AUTOMAKE_PACKAGE_NAME skipped."
else
  echo "$AUTOMAKE_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $AUTOMAKE_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$AUTOMAKE_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making coreutils again. This time with the patch. 
cd /sources
if grep -Fxq "$COREUTILS_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$COREUTILS_PACKAGE_NAME-2 skipped."
else
  echo "$COREUTILS_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $COREUTILS_PACKAGE_NAME-2
  patch -Np1 -i ../$COREUTILS_PACKAGE_NAME-i18n-2.patch
  LD_PRELOAD=/sources/uname_hack.so autoreconf -fiv
  LD_PRELOAD=/sources/uname_hack.so FORCE_UNSAFE_CONFIGURE=1 CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --enable-no-install-program=kill,uptime --libexecdir=/usr/local/lib
  echo "flto fails"
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name config.status -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  mv -v /usr/local/bin/chroot /usr/local/sbin
  echo "$COREUTILS_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making diffutils again.
cd /sources
if grep -Fxq "$DIFFUTILS_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$DIFFUTILS_PACKAGE_NAME-2 skipped."
else
  echo "$DIFFUTILS_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $DIFFUTILS_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$DIFFUTILS_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making gawk again.
cd /sources
if grep -Fxq "$GAWK_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$GAWK_PACKAGE_NAME-2 skipped."
else
  echo "$GAWK_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $GAWK_PACKAGE_NAME-2
  sed -i 's/extras//' Makefile.in
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --libexecdir=/usr/local/lib/gawk
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$GAWK_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making findutils again.
cd /sources
if grep -Fxq "$FINDUTILS_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$FINDUTILS_PACKAGE_NAME-2 skipped."
else
  echo "$FINDUTILS_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $FINDUTILS_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --localstatedir=/var/lib/locate --libexecdir=/usr/local/lib/findutils
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  # linic - the "edit /usr/local/bin/updatedb" comment from compile_tc16_x86 has been moved to prepare-additional-modifications.sh
  echo "$FINDUTILS_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making groff. 1st time!
cd /sources
if grep -Fxq "$GROFF_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$GROFF_PACKAGE_NAME skipped."
else
  echo "$GROFF_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $GROFF_PACKAGE_NAME
  # linic - the "edit /usr/bin/texi2any" comment from compile_tc16_x86 has been moved to prepare-additional-modifications.sh
  LD_PRELOAD=/sources/uname_hack.so PAGE=A4 CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$GROFF_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making gzip again.
cd /sources
if grep -Fxq "$GZIP_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$GZIP_PACKAGE_NAME-2 skipped."
else
  echo "$GZIP_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $GZIP_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$GZIP_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making make again.
cd /sources
if grep -Fxq "$MAKE_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$MAKE_PACKAGE_NAME-2 skipped."
else
  echo "$MAKE_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $MAKE_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$MAKE_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making patch again.
cd /sources
if grep -Fxq "$PATCH_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$PATCH_PACKAGE_NAME-2 skipped."
else
  echo "$PATCH_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $PATCH_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$PATCH_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making tar again.
cd /sources
if grep -Fxq "$TAR_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$TAR_PACKAGE_NAME-2 skipped."
else
  echo "$TAR_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $TAR_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so FORCE_UNSAFE_CONFIGURE=1 CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --libexecdir=/usr/local/lib/tar
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$TAR_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making texinfo again.
cd /sources
if grep -Fxq "$TEXINFO_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$TEXINFO_PACKAGE_NAME-2 skipped."
else
  echo "$TEXINFO_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $TEXINFO_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  LD_PRELOAD=/sources/uname_hack.so make TEXMF=/usr/local/share/texmf install-tex
  echo "$TEXINFO_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making util-linux again.
cd /sources
if grep -Fxq "$UTIL_LINUX_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$UTIL_LINUX_PACKAGE_NAME-2 skipped."
else
  echo "$UTIL_LINUX_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $UTIL_LINUX_PACKAGE_NAME-2
  mkdir -pv /var/lib/hwclock
  # linic - added --without-bpf and --without-lsfd and --disable-lsfd because by 4.4.302-cip97 seems too old for the bpf.h requirement of newer util-linux.
  # linic - related to previous line https://github.com/util-linux/util-linux/issues/2945
  LD_PRELOAD=/sources/uname_hack.so ADJTIME_PATH=/var/lib/hwclock/adjtime CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --disable-chfn-chsh --disable-lsfd --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-liblastlog2 --disable-static --without-bpf --without-lsfd --without-python --without-systemd --without-systemdsystemunitdir --libexecdir=/lib runstatedir=/run --docdir=/usr/local/share/doc/$UTIL_LINUX_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ldconfig
  # Required for base
  if [ ! -f /lib/libblkid.so.1 ]; then
    echo "/lib/libblkid.so.1 missing!"
    exit 500
  fi
  if [ ! -f /lib/libblkid.so.1.1.0 ]; then
    echo "/lib/libblkid.so.1.1.0 missing!"
    exit 501
  fi
  if [ ! -f /lib/libuuid.so.1 ]; then
    echo "/lib/libuuid.so.1 missing!"
    exit 502
  fi
  if [ ! -f /lib/libuuid.so.1.3.0 ]; then
    echo "/lib/libuuid.so.1.3.0 missing!"
    exit 503
  fi
  if [ ! -f /sbin/blkid ]; then
    echo "/sbin/blkid missing!"
    exit 504
  fi
  if [ ! -f /usr/bin/uuidgen ]; then
    echo "/usr/bin/uuidgen missing!"
    exit 505
  fi
  echo "$UTIL_LINUX_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making e2fsprogs. 1st time!
cd /sources
if grep -Fxq "$E2FSPROGS_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$E2FSPROGS_PACKAGE_NAME-1 skipped."
else
  echo "$E2FSPROGS_PACKAGE_NAME-1-started" | tee -a /sources/compile_sequence_history.txt
  cd $E2FSPROGS_PACKAGE_NAME-1
  mkdir build
  cd build
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ../configure --prefix=/usr --bindir=/bin --with-root-prefix="" --enable-elf-shlibs --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name Makefile -type f -exec sed -i 's/-O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  LD_PRELOAD=/sources/uname_hack.so make install-libs
  # linic - replaced `rm /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a`
  rm /usr/lib/libcom_err.a
  rm /usr/lib/libe2p.a
  rm /usr/lib/libext2fs.a
  rm /usr/lib/libss.a
  echo "checking files required for base..."
  if [ ! -f /etc/mke2fs.conf ]; then
    echo "/etc/mke2fs.conf missing!"
    exit 550
  fi
  if [ ! -f /lib/libcom_err.so.2 ]; then
    echo "/lib/libcom_err.so.2 missing!"
    exit 551
  fi
  if [ ! -f /lib/libcom_err.so.2.1 ]; then
    echo "/lib/libcom_err.so.2.1 missing!"
    exit 552
  fi
  if [ ! -f /lib/libe2p.so.2 ]; then
    echo "/lib/libe2p.so.2 missing!"
    exit 553
  fi
  if [ ! -f /lib/libe2p.so.2.3 ]; then
    echo "/lib/libe2p.so.2.3 missing!"
    exit 554
  fi
  if [ ! -f /lib/libext2fs.so.2 ]; then
    echo "/lib/libext2fs.so.2 missing!"
    exit 555
  fi
  if [ ! -f /lib/libext2fs.so.2.4 ]; then
    echo "/lib/libext2fs.so.2.4 missing!"
    exit 556
  fi
  if [ ! -f /sbin/e2fsck ]; then
    echo "/sbin/e2fsck missing!"
    exit 557
  fi
  if [ ! -f /sbin/mke2fs ]; then
    echo "/sbin/mke2fs missing!"
    exit 558
  fi
  if [ ! -f /sbin/tune2fs ]; then
    echo "/sbin/tune2fs missing!"
    exit 559
  fi
  if [ ! -f /usr/sbin/mklost+found ]; then
    echo "/usr/sbin/mklost+found missing!"
    exit 560
  fi
  echo "$E2FSPROGS_PACKAGE_NAME-1-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making util-linux again.
cd /sources
if grep -Fxq "$UTIL_LINUX_PACKAGE_NAME-3-success" compile_sequence_history.txt; then
  echo "$UTIL_LINUX_PACKAGE_NAME-3 skipped."
else
  echo "$UTIL_LINUX_PACKAGE_NAME-3-started" | tee -a /sources/compile_sequence_history.txt
  cd $UTIL_LINUX_PACKAGE_NAME-3
  # linic - added --without-bpf and --without-lsfd and --disable-lsfd because by 4.4.302-cip97 seems too old for the bpf.h requirement of newer util-linux.
  # linic - related to previous line https://github.com/util-linux/util-linux/issues/2945
  LD_PRELOAD=/sources/uname_hack.so ADJTIME_PATH=/var/lib/hwclock/adjtime CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --disable-chfn-chsh --disable-lsfd --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-liblastlog2 --disable-static --without-bpf --without-lsfd --without-python --without-systemd --without-systemdsystemunitdir --libexecdir=/usr/local/lib --localstatedir=/var runstatedir=/run --docdir=/usr/local/share/doc/$UTIL_LINUX_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$UTIL_LINUX_PACKAGE_NAME-3-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making e2fsprogs again.
cd /sources
if grep -Fxq "$E2FSPROGS_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$E2FSPROGS_PACKAGE_NAME-2 skipped."
else
  echo "$E2FSPROGS_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $E2FSPROGS_PACKAGE_NAME-2
  mkdir build
  cd build
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ../configure --prefix=/usr/local --enable-elf-shlibs --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name Makefile -type f -exec sed -i 's/-O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  LD_PRELOAD=/sources/uname_hack.so make install-libs
  # linic - replaced `rm /usr/local/lib/{libcom_err,libe2p,libext2fs,libss}.a`
  rm /usr/local/lib/libcom_err.a
  rm /usr/local/lib/libe2p.a
  rm /usr/local/lib/libext2fs.a
  rm /usr/local/lib/libss.a
  echo "$E2FSPROGS_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making tinycore sources within chroot ends here.

echo "The next script would be compile-busybox.sh. Do you want to run it now (y/n)"
read continue_y_n
if [ $continue_y_n = "y" ]; then
  /tcc/compile-busybox.sh
fi

