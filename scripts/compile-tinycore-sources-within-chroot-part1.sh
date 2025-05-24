#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Compile TC sources within chroot part 1.
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

touch /var/log/btmp
touch /var/log/lastlog
touch /var/log/faillog
touch /var/log/wtmp

chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

# Preface all configure/make commands with:
# LD_PRELOAD=/sources/uname_hack.so [32-bit version]
# https://stackoverflow.com/questions/426230/what-is-the-ld-preload-trick
# "If you set LD_PRELOAD to the path of a shared object, that file will be loaded before any other library (including the C runtime, libc.so)."

# Making gettext
cd /sources
if grep -Fxq "$GETTEXT_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$GETTEXT_PACKAGE_NAME-1 skipped."
else
  echo "$GETTEXT_PACKAGE_NAME-1-started" | tee -a /sources/compile_sequence_history.txt
  cd $GETTEXT_PACKAGE_NAME-1
  LD_PRELOAD=/sources/uname_hack.so ./configure --disable-shared
  LD_PRELOAD=/sources/uname_hack.so make
  cp -v gettext-tools/src/msgfmt /usr/bin
  cp -v gettext-tools/src/msgmerge /usr/bin
  cp -v gettext-tools/src/xgettext /usr/bin
  echo "$GETTEXT_PACKAGE_NAME-1-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making bison
cd /sources
if grep -Fxq "$BISON_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$BISON_PACKAGE_NAME-1 skipped."
else
  echo "$BISON_PACKAGE_NAME-1-started" | tee -a /sources/compile_sequence_history.txt
  cd $BISON_PACKAGE_NAME-1
  LD_PRELOAD=/sources/uname_hack.so ./configure --prefix=/usr --docdir=/usr/share/doc/$BISON_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$BISON_PACKAGE_NAME-1-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making perl
cd /sources
if grep -Fxq "$PERL_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$PERL_PACKAGE_NAME-1 skipped."
else
  echo "$PERL_PACKAGE_NAME-1-started" | tee -a /sources/compile_sequence_history.txt
  cd $PERL_PACKAGE_NAME-1
  LD_PRELOAD=/sources/uname_hack.so sh Configure -des -Dprefix=/usr -Dvendorprefix=/usr -Duseshrplib -Dprivlib=/usr/lib/perl5/5.32/core_perl -Darchlib=/usr/lib/perl5/5.32/core_perl -Dsitelib=/usr/lib/perl5/5.32/site_perl -Dsitearch=/usr/lib/perl5/5.32/site_perl -Dvendorlib=/usr/lib/perl5/5.32/vendor_perl -Dvendorarch=/usr/lib/perl5/5.32/vendor_perl
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$PERL_PACKAGE_NAME-1-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making python
cd /sources
if grep -Fxq "$PYTHON_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$PYTHON_PACKAGE_NAME skipped."
else
  echo "$PYTHON_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $PYTHON_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so ./configure --prefix=/usr --enable-shared --without-ensurepip
  # [Platform "i686-pc-linux-gnu" with compiler "gcc" is not supported by the
  # CPython core team, see https://peps.python.org/pep-0011/ for more information.]
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$PYTHON_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making texinfo
cd /sources
if grep -Fxq "$TEXINFO_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$TEXINFO_PACKAGE_NAME-1 skipped."
else
  echo "$TEXINFO_PACKAGE_NAME-1-started" | tee -a /sources/compile_sequence_history.txt
  cd $TEXINFO_PACKAGE_NAME-1
  LD_PRELOAD=/sources/uname_hack.so ./configure --prefix=/usr
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$TEXINFO_PACKAGE_NAME-1-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making $UTIL_LINUX_PACKAGE_NAME
cd /sources
if grep -Fxq "$UTIL_LINUX_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$UTIL_LINUX_PACKAGE_NAME-1 skipped."
else
  echo "$UTIL_LINUX_PACKAGE_NAME-1-started" | tee -a /sources/compile_sequence_history.txt
  cd $UTIL_LINUX_PACKAGE_NAME-1
  if grep -Fxq "tty:x:5:" /etc/group; then
    echo "tty:x:5: already in /etc/group."
  else
    echo "Adding tty:x:5: to /etc/group"
    echo "tty:x:5:" >> /etc/group
  fi
  mkdir -pv /var/lib/hwclock
  # linic - added --without-bpf and --without-lsfd and --disable-lsfd because by 4.4.302-cip97 seems too old for the bpf.h requirement of newer util-linux.
  # linic - related to previous line https://github.com/util-linux/util-linux/issues/2945
  LD_PRELOAD=/sources/uname_hack.so ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime --libdir=/usr/lib --runstatedir=/run --disable-chfn-chsh --disable-lsfd --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static --disable-liblastlog2 --without-bpf --without-lsfd --without-python --docdir=/usr/share/doc/$UTIL_LINUX_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "----"
  # linic - replaced `find /usr/{lib,libexec} -name \*.la -delete`
  find /usr/lib -name '*.la' -delete
  find /usr/libexec -name '*.la' -delete
  # linic - replaced `rm -rf /usr/share/{info,man,doc}/*`
  rm -rf /usr/share/info/*
  rm -rf /usr/share/man/*
  rm -rf /usr/share/doc/*
  echo "----"
  echo "$UTIL_LINUX_PACKAGE_NAME-1-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making somthing for C++
cd /sources
if grep -Fxq "$GLIBC_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$GLIBC_PACKAGE_NAME-2 skipped."
else
  echo "$GLIBC_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $GLIBC_PACKAGE_NAME-2
  mkdir build
  cd build
  echo "rootsbindir=/usr/sbin" > configparms
  echo "[still get libexec...]"
  echo "linic - what was the meaning of [still get libexec...]?"
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" ../configure --prefix=/usr --disable-werror --enable-kernel=$ENABLE_KERNEL --enable-stack-protector=strong libc_cv_slibdir=/lib --enable-obsolete-rpc --libexecdir=/usr/lib/glibc
  # linic - I won't make these into a patch because the ../configure has to be called for these to exist and, for now,
  # I want to patch all files before any configure or make call..
  find . -name config.make -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name config.status -type f -exec sed -i 's/-g -O2//g' {} \;
  find ../ -name Makeconfig -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make V=1 2>&1 | tee make.log
  touch /etc/ld.so.conf
  sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
  echo "[install install_root=/tmp/pkg] [/usr/include/gnu/stubs64.h missing]"
  echo "linic - not sure what the previous comment would mean I should do something here..."
  LD_PRELOAD=/sources/uname_hack.so make install
  sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
  make localedata/install-locales
  localedef -i C -f UTF-8 C.UTF-8
  localedef -i ja_JP -f SHIFT_JIS ja_JP.SIJS 2> /dev/null || true
  # [copy tc /etc/nsswitch.conf and /etc/ld.so.conf files to $TC/etc]
  # linic - backtrack to a copy of this comment and you'll see where I copied those. I can't copy those here, because the chroot has already been done.
  echo "$GLIBC_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making zlib
# https://zlib.net/
cd /sources
if grep -Fxq "$ZLIB_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$ZLIB_PACKAGE_NAME skipped."
else
  echo "$ZLIB_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $ZLIB_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr
  find . -name Makefile -type f -exec sed -i 's/-O3//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$ZLIB_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making bzip2
cd /sources
if grep -Fxq "$BZIP2_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$BZIP2_PACKAGE_NAME skipped."
else
  echo "$BZIP2_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $BZIP2_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so make -f Makefile-libbz2_so
  LD_PRELOAD=/sources/uname_hack.so make clean
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make PREFIX=/usr/local install
  cp bzip2-shared /usr/local/bin/bzip2
  cp -a libbz2.so* /usr/local/lib
  cd /usr/local/lib
  ln -s libbz2.so.1.0 libbz2.so
  cd ../bin
  # linic - replaced `rm {bunzip2,bzcat}`
  rm bunzip2
  rm bzcat
  ln -s bzip2 bunzip2
  ln -s bzip2 bzcat
  ldconfig
  echo "$BZIP2_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making $XZ_PACKAGE_NAME again with different settings.
cd /sources
if grep -Fxq "$XZ_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$XZ_PACKAGE_NAME-2 skipped."
else
  echo "$XZ_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $XZ_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --disable-static --docdir=/usr/local/share/doc/$XZ_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ldconfig
  echo "$XZ_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making zstd
cd /sources
if grep -Fxq "$ZSTD_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$ZSTD_PACKAGE_NAME skipped."
else
  echo "$ZSTD_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $ZSTD_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-O3//g' {} \;
  find . -name libzstd.mk -type f -exec sed -i 's/-O3//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti"
  LD_PRELOAD=/sources/uname_hack.so make CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" prefix=/usr/local install
  ldconfig
  echo "$ZSTD_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making file again
cd /sources
if grep -Fxq "$FILE_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$FILE_PACKAGE_NAME-2 skipped."
else
  echo "$FILE_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $FILE_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ldconfig
  echo "$FILE_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making $READLINE_PACKAGE_NAME
cd /sources
if grep -Fxq "$READLINE_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$READLINE_PACKAGE_NAME skipped."
else
  echo "$READLINE_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $READLINE_PACKAGE_NAME
  sed -i '/MV.*old/d' Makefile.in
  sed -i '/{OLDSUFF}/c:' support/shlib-install
  sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --disable-static --with-curses --docdir=/usr/local/share/doc/$READLINE_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make SHLIB_LIBS="-lncursesw"
  LD_PRELOAD=/sources/uname_hack.so make SHLIB_LIBS="-lncursesw" install
  echo "$READLINE_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making m4 again
cd /sources
if grep -Fxq "$M4_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$M4_PACKAGE_NAME-2 skipped."
else
  echo "$M4_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $M4_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$M4_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making bc
cd /sources
if grep -Fxq "$BC_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$BC_PACKAGE_NAME skipped."
else
  echo "$BC_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $BC_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" ./configure  --prefix=/usr/local -G -r
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$BC_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making flex
cd /sources
if grep -Fxq "$FLEX_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$FLEX_PACKAGE_NAME skipped."
else
  echo "$FLEX_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $FLEX_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --docdir=/usr/local/share/doc/$FLEX_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ln -sv flex /usr/local/bin/lex
  ldconfig
  echo "$FLEX_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making pkg-config
cd /sources
if grep -Fxq "$PKG_CONFIG_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$PKG_CONFIG_PACKAGE_NAME skipped."
else
  echo "$PKG_CONFIG_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $PKG_CONFIG_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --with-internal-glib --disable-host-tool --docdir=/usr/local/share/doc/$PKG_CONFIG_PACKAGE_NAME --with-pc-path="/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/share/pkgconfig"
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name Makefile -type f -exec sed -i 's/-g -Wall -O2/-Wall/g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "$PKG_CONFIG_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making binutils. 3rd time?? using the patch this time
cd /sources
if grep -Fxq "$BINUTILS_PACKAGE_NAME-3-success" compile_sequence_history.txt; then
  echo "$BINUTILS_PACKAGE_NAME-3 skipped."
else
  echo "$BINUTILS_PACKAGE_NAME-3-started" | tee -a /sources/compile_sequence_history.txt
  cd $BINUTILS_PACKAGE_NAME-3
  mkdir build
  cd build
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe" ../configure --prefix=/usr --sysconfdir=/etc --enable-gold --enable-ld=default --enable-plugins --enable-shared --disable-werror --enable-64-bit-bfd --enable-new-dtags --with-system-zlib --enable-default-hash-style=gnu
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name Makefile -type f -exec sed -i 's/-O2 -g//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make tooldir=/usr
  LD_PRELOAD=/sources/uname_hack.so make tooldir=/usr install
  # linic - replaced `rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a`
  rm -fv /usr/lib/libbfd.a
  rm -fv /usr/lib/libctf.a
  rm -fv /usr/lib/libctf-nobfd.a
  rm -fv /usr/lib/libgprofng.a
  rm -fv /usr/lib/libopcodes.a
  rm -fv /usr/lib/libsframe.a
  echo "$BINUTILS_PACKAGE_NAME-3-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making gmp
cd /sources
if grep -Fxq "$GMP_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$GMP_PACKAGE_NAME skipped."
else
  echo "$GMP_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $GMP_PACKAGE_NAME
  # linic - replaced `mv config{fsf,}.guess`
  mv configfsf.guess config.guess
  # linic - replaced `mv config{fsf,}.sub`
  mv configfsf.sub config.sub
  LD_PRELOAD=/sources/uname_hack.so CFLAGS="-march=$MARCH -mtune=$MTUNE -Os -pipe" CXXFLAGS="-march=$MARCH -mtune=$MTUNE -Os -pipe" ABI=32 ./configure --prefix=/usr/local --enable-cxx --disable-static --docdir=/usr/local/share/doc/$GMP_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ldconfig
  echo "$GMP_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making mpfr
cd /sources
if grep -Fxq "$MPFR_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$MPFR_PACKAGE_NAME skipped."
else
  echo "$MPFR_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $MPFR_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe" ./configure --prefix=/usr/local --disable-static --enable-thread-safe --docdir=/usr/local/share/doc/$MPFR_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ldconfig
  echo "$MPFR_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making mpc
cd /sources
if grep -Fxq "$MPC_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$MPC_PACKAGE_NAME skipped."
else
  echo "$MPC_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $MPC_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe" ./configure --prefix=/usr/local --disable-static --docdir=/usr/local/share/doc/$MPC_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ldconfig
  echo "$MPC_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making isl
cd /sources
if grep -Fxq "$ISL_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$ISL_PACKAGE_NAME skipped."
else
  echo "$ISL_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $ISL_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe" ./configure --prefix=/usr/local --disable-static
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name Makefile -type f -exec sed -i 's/-O3//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  mkdir -p /usr/local/share/gdb/auto-load/usr/local/lib/
  mv /usr/local/lib/*gdb.py /usr/local/share/gdb/auto-load/usr/local/lib/
  ldconfig
  echo "$ISL_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making libxcrypt
cd /sources
if grep -Fxq "$LIBXCRYPT_PACKAGE_NAME-success" compile_sequence_history.txt; then
  echo "$LIBXCRYPT_PACKAGE_NAME skipped."
else
  echo "$LIBXCRYPT_PACKAGE_NAME-started" | tee -a /sources/compile_sequence_history.txt
  cd $LIBXCRYPT_PACKAGE_NAME
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe" ./configure --prefix=/usr --enable-hashes=strong,glibc --enable-obsolete-api=glibc --disable-static --disable-failure-tokens
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ldconfig
  echo "$LIBXCRYPT_PACKAGE_NAME-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making gcc again...???
cd /sources
if grep -Fxq "$GCC_PACKAGE_NAME-4-success" compile_sequence_history.txt; then
  echo "$GCC_PACKAGE_NAME-4 skipped."
else
  echo "$GCC_PACKAGE_NAME-4-started" | tee -a /sources/compile_sequence_history.txt
  cd $GCC_PACKAGE_NAME-4
  mkdir build
  cd build
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe" ../configure --prefix=/usr LD=ld --enable-languages=c,c++ --enable-default-pie --enable-default-ssp --enable-host-pie --disable-multilib --disable-bootstrap --disable-fixincludes --with-system-zlib --libexecdir=/usr/lib
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name Makefile -type f -exec sed -i 's/-O2 -g//g' {} \;
  find . -name config.status -type f -exec sed -i 's/-g -O2//g' {} \;
  # [-O2 still appears building libs]
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  ln -svr /usr/bin/cpp /usr/lib
  ln -sfv ../../lib/gcc/$(gcc -dumpmachine)/14.2.0/liblto_plugin.so /usr/lib/bfd-plugins/
  mkdir -pv /usr/share/gdb/auto-load/usr/lib
  mv -v /usr/lib/*gdb.py /usr/local/share/gdb/auto-load/usr/lib
  echo 'int main(){}' > dummy.c
  cc dummy.c -v -Wl,--verbose &> dummy.log
  readelf -l a.out | grep ': /lib'
  echo "[Requesting program interpreter: /lib/ld-linux.so.2]"
  echo "searching to confirm toolchain is good 1:"
  grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
  echo "expecting:"
  echo "/usr/lib/gcc/i686-pc-linux-gnu/14.2.0/../../../crti.o succeeded"
  echo "/usr/lib/gcc/i686-pc-linux-gnu/14.2.0/../../../crtn.o succeeded"
  echo "continue?"
  read ignore_me
  grep -B4 '^ /usr/include' dummy.log
  #include <...> search starts here:
  # /usr/lib/gcc/i686-pc-linux-gnu/13.2.0/include
  # /usr/local/include
  # /usr/lib/gcc/i686-pc-linux-gnu/13.2.0/include-fixed
  # /usr/include
  echo "searching to confirm toolchain is good 2:"
  grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
  echo "expecting:"
  echo "SEARCH_DIR(\"/usr/i686-pc-linux-gnu/lib32\")"
  echo "SEARCH_DIR(\"/usr/local/lib32\")"
  echo "SEARCH_DIR(\"/lib32\")"
  echo "SEARCH_DIR(\"/usr/lib32\")"
  echo "SEARCH_DIR(\"/usr/i686-pc-linux-gnu/lib\")"
  echo "SEARCH_DIR(\"/usr/local/lib\")"
  echo "SEARCH_DIR(\"/lib\")"
  echo "SEARCH_DIR(\"/usr/lib\");"
  echo "continue?"
  read ignore_me
  echo "searching to confirm toolchain is good 3:"
  grep "/lib.*/libc.so.6 " dummy.log
  echo "expecting:"
  echo "attempt to open /lib/libc.so.6 succeeded"
  echo "continue?"
  read ignore_me
  echo "searching to confirm toolchain is good 4:"
  grep found dummy.log
  echo "expecting:"
  echo "found ld-linux.so.2 at /lib/ld-linux.so.2"
  echo "continue?"
  read ignore_me
  rm -v dummy.c a.out dummy.log
  echo "$GCC_PACKAGE_NAME-4-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making binutils. 4th time... the patch is there since the 3rd time binutil got built
cd /sources
if grep -Fxq "$BINUTILS_PACKAGE_NAME-4-success" compile_sequence_history.txt; then
  echo "$BINUTILS_PACKAGE_NAME-4 skipped."
else
  echo "$BINUTILS_PACKAGE_NAME-4-started" | tee -a /sources/compile_sequence_history.txt
  cd $BINUTILS_PACKAGE_NAME-4
  mkdir build
  cd build
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe" ../configure --prefix=/usr/local  --sysconfdir=/etc --enable-gold --enable-ld=default --enable-plugins --enable-shared --disable-werror --enable-64-bit-bfd --enable-new-dtags --with-system-zlib --enable-default-hash-style=gnu
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name Makefile -type f -exec sed -i 's/-O2 -g//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make tooldir=/usr/local
  # linic - Marking the time before the install command to locate files (not directories) modified during the install.
  touch $BINUTILS_PACKAGE_NAME-4-time-marker
  LD_PRELOAD=/sources/uname_hack.so make tooldir=/usr/local install
  # linic - replaced `rm -fv /usr/local/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a`
  rm -fv /usr/local/lib/libbfd.a
  rm -fv /usr/local/lib/libctf.a
  rm -fv /usr/local/lib/libctf-nobfd.a
  rm -fv /usr/local/lib/libgprofng.a
  rm -fv /usr/local/lib/libopcodes.a
  rm -fv /usr/local/lib/libsframe.a
  echo "[remove binutils from /usr]"
  if [ ! -f binutils_usr.tce.list ]; then
    touch $BINUTILS_PACKAGE_NAME-4.candidates.files
    echo "remove-binutils-from/usr" >> $BINUTILS_PACKAGE_NAME-4.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $BINUTILS_PACKAGE_NAME-4.candidates.files
    find / -not -type 'd' -cnewer $BINUTILS_PACKAGE_NAME-4-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $BINUTILS_PACKAGE_NAME-4.candidates.files
    # linic - I can't edit in the chroot environment yet because there's no editor. See the prepare-tce.list.sh and remove-files-chroot.sh for more details.
    #vi $BINUTILS_PACKAGE_NAME-4.candidates.files
    #mv $BINUTILS_PACKAGE_NAME-4.candidates.files binutils_usr.tce.list
  fi
  if [ -f binutils_usr.tce.list ]; then
    for file in `cat binutils_usr.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done
  fi
  ldconfig
  echo "$BINUTILS_PACKAGE_NAME-4-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making gcc again. Each time, the settings with ../configure change a bit.
# last time, --libexecdir=/usr/lib and this time it's --libexecdir=/usr/local/lib
cd /sources
if grep -Fxq "$GCC_PACKAGE_NAME-5-success" compile_sequence_history.txt; then
  echo "$GCC_PACKAGE_NAME-5 skipped."
else
  echo "$GCC_PACKAGE_NAME-5-started" | tee -a /sources/compile_sequence_history.txt
  cd $GCC_PACKAGE_NAME-5
  mkdir build
  cd build
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe" ../configure --prefix=/usr/local LD=ld --enable-languages=c,c++ --enable-default-pie --enable-default-ssp --enable-host-pie --disable-multilib --disable-bootstrap --disable-fixincludes --with-system-zlib --libexecdir=/usr/local/lib
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  find . -name Makefile -type f -exec sed -i 's/-O2 -g//g' {} \;
  find . -name config.status -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  touch $GCC_PACKAGE_NAME-5-time-marker
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "check"
  ln -sv /usr/local/bin/gcc /usr/local/bin/cc
  ln -sv /usr/local/bin/cpp /usr/local/lib
  LD_PRELOAD=/sources/uname_hack.so install -v -dm755 /usr/local/lib/bfd-plugins
  ln -sfv /usr/local/lib/gcc/$(gcc -dumpmachine)/14.2.0/liblto_plugin.so /usr/local/lib/bfd-plugins/
  mkdir -pv /usr/local/share/gdb/auto-load/usr/local/lib
  mv -v /usr/local/lib/*gdb.py /usr/local/share/gdb/auto-load/usr/local/lib
  echo "[remove gcc from /usr except libstdc++ and libgcc_s]"
  # linic - I couldn't recreate these 2 files, but using the same technique as binutils, gcc_usr_local_remove.tce.list should be equivalent I hope.
  # for file in `cat gcc_usr_remove.tce.list`; do rm "$file" ; done
  # for file in `cat gcc_local_remove.tce.list`; do rm "$file" ; done
  if [ ! -f gcc_usr_local_remove.tce.list ]; then
    touch $GCC_PACKAGE_NAME-5.candidates.files
    echo "remove-gcc-from/usr-except-libstdc++-and-libgcc_s" >> $GCC_PACKAGE_NAME-5.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $GCC_PACKAGE_NAME-5.candidates.files
    find / -not -type 'd' -cnewer $GCC_PACKAGE_NAME-5-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $GCC_PACKAGE_NAME-5.candidates.files
    #vi $GCC_PACKAGE_NAME-5.candidates.files
    #mv $GCC_PACKAGE_NAME-5.candidates.files gcc_usr_local_remove.tce.list
  fi
  if [ -f gcc_usr_local_remove.tce.list ]; then
    for file in `cat gcc_usr_local_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done
  fi
  ldconfig
  echo "$GCC_PACKAGE_NAME-5-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making ncurses again.
cd /sources
if grep -Fxq "$NCURSES_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$NCURSES_PACKAGE_NAME-2 skipped."
else
  echo "$NCURSES_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $NCURSES_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --mandir=/usr/local/share/man --with-shared --without-debug --without-normal --with-cxx-shared --enable-pc-files --enable-widec --with-pkg-config-libdir=/usr/local/lib/pkgconfig
  find . -name Makefile -type f -exec sed -i 's/-O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  touch $NCURSES_PACKAGE_NAME-2-time-marker
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "[remove ncurses from /usr]"
  if [ ! -f ncurses_usr_remove.tce.list ]; then
    touch $NCURSES_PACKAGE_NAME-2.candidates.files
    echo "remove-ncurses-from/usr" >> $NCURSES_PACKAGE_NAME-2.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $NCURSES_PACKAGE_NAME-2.candidates.files
    find / -not -type 'd' -cnewer $NCURSES_PACKAGE_NAME-2-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $NCURSES_PACKAGE_NAME-2.candidates.files
    #vi $NCURSES_PACKAGE_NAME-2.candidates.files
    #mv $NCURSES_PACKAGE_NAME-2.candidates.files ncurses_usr_remove.tce.list
  fi
  if [ -f ncurses_usr_remove.tce.list ]; then
    for file in `cat ncurses_usr_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done
  fi
  ldconfig
  echo "$NCURSES_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making sed again.
cd /sources
if grep -Fxq "$SED_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$SED_PACKAGE_NAME-2 skipped."
else
  echo "$SED_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $SED_PACKAGE_NAME-2
  CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "[rm /usr/bin/sed]"
  # linic - I wonder if I should have used the same time-marker technique or if rm -fv /usr/bin/sed is really enough...
  rm -fv /usr/bin/sed
  echo "$SED_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making gettext again
cd /sources
if grep -Fxq "$GETTEXT_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$GETTEXT_PACKAGE_NAME-2 skipped."
else
  echo "$GETTEXT_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $GETTEXT_PACKAGE_NAME-2
  sed -e '/libxml\/xmlerror.h/i #include <libxml/xmlversion.h>' -e 's/xmlError *err/const &/' -i gettext-tools/src/its.c
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --disable-static --docdir=/usr/local/share/doc/$GETTEXT_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  chmod -v 0755 /usr/local/lib/preloadable_libintl.so
  # linic - replaced `rm -fv /usr/bin/{msgfmt,msgmerge,xgettext}`
  rm -fv /usr/bin/msgfmt
  rm -fv /usr/bin/msgmerge
  rm -fv /usr/bin/xgettext
  ldconfig
  echo "$GETTEXT_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making bison again
cd /sources
if grep -Fxq "$BISON_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$BISON_PACKAGE_NAME-2 skipped."
else
  echo "$BISON_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $BISON_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --docdir=/usr/local/share/doc/$BISON_PACKAGE_NAME
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  touch $BISON_PACKAGE_NAME-2-time-marker
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "[remove bison files from /usr]"
  if [ ! -f bison_usr_remove.tce.list ]; then
    touch $BISON_PACKAGE_NAME-2.candidates.files
    echo "remove-bison-from/usr" >> $BISON_PACKAGE_NAME-2.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $BISON_PACKAGE_NAME-2.candidates.files
    find / -not -type 'd' -cnewer $BISON_PACKAGE_NAME-2-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $BISON_PACKAGE_NAME-2.candidates.files
    #vi $BISON_PACKAGE_NAME-2.candidates.files
    #mv $BISON_PACKAGE_NAME-2.candidates.files bison_usr_remove.tce.list
  fi
  if [ -f bison_usr_remove.tce.list ]; then
    for file in `cat bison_usr_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done
  fi
  echo "$BISON_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making grep again
cd /sources
if grep -Fxq "$GREP_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$GREP_PACKAGE_NAME-2 skipped."
else
  echo "$GREP_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $GREP_PACKAGE_NAME-2
  sed -i "s/echo/#echo/" src/egrep.sh
  LD_PRELOAD=/sources/uname_hack.so CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  touch $GREP_PACKAGE_NAME-2-time-marker
  LD_PRELOAD=/sources/uname_hack.so make install
  if [ ! -f grep_usr_bin_remove.tce.list ]; then
    touch $GREP_PACKAGE_NAME-2.candidates.files
    echo "remove-grep-from/usr/bin" >> $GREP_PACKAGE_NAME-2.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $GREP_PACKAGE_NAME-2.candidates.files
    find / -not -type 'd' -cnewer $GREP_PACKAGE_NAME-2-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $GREP_PACKAGE_NAME-2.candidates.files
    #vi $GREP_PACKAGE_NAME-2.candidates.files
    #mv $GREP_PACKAGE_NAME-2.candidates.files grep_usr_bin_remove.tce.list
  fi
  if [ -f grep_usr_bin_remove.tce.list ]; then
    for file in `cat grep_usr_bin_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done
  fi
  echo "$GREP_PACKAGE_NAME-2-success" | tee -a /sources/compile_sequence_history.txt
fi
# Making bash again
cd /sources
if grep -Fxq "$BASH_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$BASH_PACKAGE_NAME-2 skipped."
else
  echo "$BASH_PACKAGE_NAME-2-started" | tee -a /sources/compile_sequence_history.txt
  cd $BASH_PACKAGE_NAME-2
  LD_PRELOAD=/sources/uname_hack.so LIBS="-lncursesw" CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local --docdir=/usr/local/share/doc/$BASH_PACKAGE_NAME --without-bash-malloc --with-installed-readline
  find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
  LD_PRELOAD=/sources/uname_hack.so make
  LD_PRELOAD=/sources/uname_hack.so make install
  cd /bin
  rm -fv bash
  rm -fv sh
  # linic - this failed on first run so I had to add the rm -fv bash 2 lines before this comment.
  ln -sv /usr/local/bin/bash ./bash
  ln -sv /usr/local/bin/bash ./sh
  # linic - exec exits the current shell. I split the compile script in -part2.sh
  echo "linic - the $BASH_PACKAGE_NAME-2-success will be written by compile-tinycore-sources-within-chroot-part2.sh"
fi
# linic - I moved the exec here since it makes more sense.
echo "You'll get a new prompt. Run compile-tinycore-sources-within-chroot-part2.sh"
exec /bin/bash --login +h
