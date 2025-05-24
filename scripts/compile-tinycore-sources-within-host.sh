#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/tcl-core-560z                          #
###################################################################

###################################################################
# Compile TC sources part 1.
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

# I wrote this script by reading each line of compile_tc16_x86 which are the build notes
# taken during the building of tc16. I filled the gaps and followed as closely as possible the
# notes saying to replace lines in some files. The end result is not accurately reproducing
# the original steps, but it should be close enough and it should work.
# See also compile-tinycore-sources-within-chroot.sh and compile-busybox.sh.

export TC=/mnt/tc
# LIBRARY_PATH and LD_LIBRARY_PATH need to be defined otherwise,
# cc configure step "checking whether the C compiler works" fails because
# "gcc: fatal error: cannot execute 'cc1': posix_spawnp: No such file or directory"
# Using find /usr -name cc1, I found /usr/local/lib/gcc/i486-pc-linux-gnu/14.2.0/cc1
#export LIBRARY_PATH=/usr/local/lib
#export LD_LIBRARY_PATH=/usr/local/lib

echo "..."
echo "TC=$TC"
echo "TC_TGT=$TC_TGT"
echo "..."
echo "Are the lines between ... displaying the right values? (y/n)"
read continue_y_n
if [ ! $continue_y_n = "y" ]; then
  exit 1
else
  echo "Continuing with the script."
fi

cd $TC/sources
# Making binutils. 1st time.
# TODO make ALL the tar names configurable so I can easily grab a gz or xz and also change the version of the dependencies.
if grep -Fxq "$BINUTILS_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo skipping $BINUTILS_PACKAGE_NAME-1.
else
  echo "$BINUTILS_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $BINUTILS_PACKAGE_NAME-1
  mkdir build
  cd build
  if ../configure --prefix=$TC/tools --with-sysroot=$TC --target=$TC_TGT --disable-nls --enable-gprofng=no --disable-werror --enable-new-dtags --enable-default-hash-style=gnu; then
    make
    make install
    cd $TC/sources
    echo "$BINUTILS_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
  else
    echo "$BINUTILS_PACKAGE_NAME-1-failure" | tee -a compile_sequence_history.txt
    exit 24311
  fi
fi

# Making gcc.
if grep -Fxq "$GCC_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "skipping $GCC_PACKAGE_NAME-1"
else
  echo "$GCC_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $GCC_PACKAGE_NAME-1
  mkdir build
  cd build
  if ../configure --target=$TC_TGT --prefix=$TC/tools --with-glibc-version=2.40 --with-sysroot=$TC --with-newlib --without-headers --enable-default-pie --enable-default-ssp --disable-nls --disable-shared --disable-multilib --disable-threads --disable-libatomic --disable-libgomp --disable-libquadmath --disable-libssp --disable-libvtv --disable-libstdcxx --enable-languages=c,c++; then
    make
    make install
    cd ..
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $($TC_TGT-gcc -print-libgcc-file-name)`/include/limits.h
    cd $TC/sources
    echo "$GCC_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
  else
    echo "$GCC_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
    exit 14201
  fi
fi
# Making kernel headers (glibc needs this)
if grep -Fxq "$LINUX_PACKAGE_NAME-started" compile_sequence_history.txt; then
  echo "Skipping $LINUX_PACKAGE_NAME."
else
  echo "$LINUX_PACKAGE_NAME-started" | tee -a compile_sequence_history.txt
  cd $LINUX_PACKAGE_NAME
  # This deletes the .config if present.
  make mrproper
  # make headers, find, cp is the way in compile_tc16_x86 to generate the headers.
  # make headers
  # find usr/include -name '.*h' -delete
  # cp -rv usr/include $TC/usr
  # http://tinycorelinux.net/8.x/x86/release/src/toolchain/compile_tc8_x86
  # indicates to do make INSTALL_HDR_PATH
  # since make mrproper deletes .config and I think the .config is required, I'll copy it again
  cp $TC/sources/.config-v4.x ./.config
  make INSTALL_HDR_PATH=dest headers_install
  # cp -rv dest/include/* /tools/include
  # which I changed to adapt this to the compile_tc16_x86 logic:
  find dest/include -name '.*h' -delete
  cp -rv dest/include $TC/usr
  cd $TC/sources
  echo "$LINUX_PACKAGE_NAME-success" | tee -a compile_sequence_history.txt
fi 
# Making glibc.
if grep -Fxq "$GLIBC_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "Skipping $GLIBC_PACKAGE_NAME-1-success."
else
  echo "$GLIBC_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $GLIBC_PACKAGE_NAME-1
  mkdir build
  cd build
  echo "rootsbindir=/usr/sbin" > configparms
  ../configure --prefix=/usr --host=$TC_TGT --build=$(../scripts/config.guess) --enable-kernel=$ENABLE_KERNEL --with-headers=$TC/usr/include --disable-nscd libc_cv_slibdir=/lib
  make
  make DESTDIR=$TC install
  # The sequence is verifying that your newly built GCC is properly configured to use the correct dynamic linker path.
  sed '/RTLDLIST=/s@/usr@@g' -i $TC/usr/bin/ldd
  echo 'int main(){}' > dummy.c
  $TC_TGT-gcc dummy.c
  readelf -l a.out | grep '/ld-linux'
  echo "[Requesting program interpreter: /lib/ld-linux.so.2]"
  rm dummy.c a.out
  # The testing sequence ends here. This verification step is crucial in the Linux From Scratch (LFS) or similar
  # build processes to ensure that your toolchain is properly configured before proceeding to the next steps. If
  # you see something different than the expected path, that would indicate a problem that needs to be fixed
  # before continuing.
  cd $TC/sources
  echo "$GLIBC_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi 
# Making libstdc++
if grep -Fxq "$GCC_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "Skipping $GCC_PACKAGE_NAME-2."
else
  echo "$GCC_PACKAGE_NAME-2-started" | tee -a compile_sequence_history.txt
  cd $GCC_PACKAGE_NAME-2
  mkdir build
  cd build
  ../libstdc++-v3/configure --host=$TC_TGT --build=$(../config.guess) --prefix=/usr --disable-multilib --disable-nls --disable-libstdcxx-pch --with-gxx-include-dir=/tools/$TC_TGT/include/c++/14.2.0
  make
  make DESTDIR=$TC install
  # linic - this rm fails because there's nothing there like this?
  #rm -v $TC/usr/lib/lib{stdc++{,exp,fs},supc++}.la
  # linic - replaced it with this loop which checks if the file exists before calling the remove.
  # linic - I also replaced the brace expansion to make this more portable.
  for file in \
    "$TC/usr/lib/libstdc++.la" \
    "$TC/usr/lib/libstdc++exp.la" \
    "$TC/usr/lib/libstdc++fs.la" \
    "$TC/usr/lib/libsupc++.la"
  do
    [ -e "$file" ] && rm -v "$file"
  done
  cd $TC/sources
  echo "$GCC_PACKAGE_NAME-2-success" | tee -a compile_sequence_history.txt
fi 
# Making m4
if grep -Fxq "$M4_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "Skipping $M4_PACKAGE_NAME-1."
else
  echo "$M4_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $M4_PACKAGE_NAME-1
  if ./configure --prefix=/usr --host=$TC_TGT --build=$(build-aux/config.guess); then
    make
    make DESTDIR=$TC install
    cd $TC/sources
    echo "$M4_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
  else
    exit 14191
  fi
fi 
# Making ncurses
if grep -Fxq "$NCURSES_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "Skipping $NCURSES_PACKAGE_NAME-1."
else
  echo "$NCURSES_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $NCURSES_PACKAGE_NAME-1
  mkdir build
  cd build
    ../configure
    make -C include
    make -C progs tic
  cd ..
  ./configure --prefix=/usr --host=$TC_TGT --build=$(./config.guess) --mandir=/usr/share/man --with-manpage-format=normal --with-shared --without-normal --with-cxx-shared --without-debug --without-ada --disable-stripping AWK=gawk
  make
  make DESTDIR=$TC TIC_PATH=$(pwd)/build/progs/tic install
  ln -sv libncursesw.so $TC/usr/lib/libncurses.so
  sed -e 's/^#if.*XOPEN.*$/#if 1/' -i $TC/usr/include/curses.h
  cd $TC/sources
  echo "$NCURSES_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi 
# Making bash
if grep -Fxq "$BASH_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "Skipping $BASH_PACKAGE_NAME-1."
else
  echo "$BASH_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $BASH_PACKAGE_NAME-1
  ./configure --prefix=/usr --build=$(sh support/config.guess) --host=$TC_TGT --without-bash-malloc
  make
  make DESTDIR=$TC install
  ln -sv $TC/usr/bin/bash $TC/bin/sh
  ln -sv $TC/usr/bin/bash $TC/bin/bash
  cd $TC/sources
  echo "$BASH_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi 
# Making coreutils
if grep -Fxq "$COREUTILS_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$COREUTILS_PACKAGE_NAME-1 skipped."
else
  echo "$COREUTILS_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $COREUTILS_PACKAGE_NAME-1
  # linic - the patch named $COREUTILS_PACKAGE_NAME-i18n-2.patch is used when this is built a second time in the chroot.
  ./configure --prefix=/usr --host=$TC_TGT --build=$(build-aux/config.guess) --enable-install-program=hostname --enable-no-install-program=kill,uptime
  make
  make DESTDIR=$TC install
  mv -v $TC/usr/bin/chroot $TC/usr/sbin
  mkdir -pv $TC/usr/share/man/man8
  mv -v $TC/usr/share/man/man1/chroot.1 $TC/usr/share/man/man8/chroot.8
  sed -i 's/"1"/"8"/' $TC/usr/share/man/man8/chroot.8
  cd $TC/sources
  echo "$COREUTILS_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making diffutils
if grep -Fxq "$DIFFUTILS_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$DIFFUTILS_PACKAGE_NAME-1 skipped."
else
  echo "$DIFFUTILS_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $DIFFUTILS_PACKAGE_NAME-1
  ./configure --prefix=/usr --host=$TC_TGT --build=$(./build-aux/config.guess)
  make
  make DESTDIR=$TC install
  cd $TC/sources
  echo "$DIFFUTILS_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making file
if grep -Fxq "$FILE_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$FILE_PACKAGE_NAME-1 skipped."
else
  echo "$FILE_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $FILE_PACKAGE_NAME-1
  mkdir build
  cd build
  ../configure --disable-bzlib --disable-libseccomp --disable-xzlib --disable-zlib
  make
  cd ..
  ./configure --prefix=/usr --host=$TC_TGT --build=$(./config.guess)
  make FILE_COMPILE=$(pwd)/build/src/file
  make DESTDIR=$TC install
  rm -v $TC/usr/lib/libmagic.la
  cd $TC/sources
  echo "$FILE_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making findutils
if grep -Fxq "$FINDUTILS_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$FINDUTILS_PACKAGE_NAME-1 skipped."
else
  echo "$FINDUTILS_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $FINDUTILS_PACKAGE_NAME-1
  ./configure --prefix=/usr -localstatedir=/var/lib/locate --host=$TC_TGT --build=$(build-aux/config.guess)
  make
  make DESTDIR=$TC install
  cd $TC/sources
  echo "$FINDUTILS_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making gawk
if grep -Fxq "$GAWK_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$GAWK_PACKAGE_NAME-1 skipped."
else
  echo "$GAWK_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $GAWK_PACKAGE_NAME-1
  ./configure --prefix=/usr --host=$TC_TGT --build=$(build-aux/config.guess)
  make
  make DESTDIR=$TC install
  cd $TC/sources
  echo "$GAWK_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making grep
if grep -Fxq "$GREP_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$GREP_PACKAGE_NAME-1 skipped."
else
  echo "$GREP_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $GREP_PACKAGE_NAME-1
  ./configure --prefix=/usr --host=$TC_TGT --build=$(./build-aux/config.guess) --disable-perl-regexp
  make
  make DESTDIR=$TC install
  cd $TC/sources
  echo "$GREP_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making gzip
if grep -Fxq "$GZIP_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$GZIP_PACKAGE_NAME-1 skipped."
else
  echo "$GZIP_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $GZIP_PACKAGE_NAME-1
  ./configure --prefix=/usr --host=$TC_TGT
  make
  make DESTDIR=$TC install
  cd $TC/sources
  echo "$GZIP_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making make
if grep -Fxq "$MAKE_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$MAKE_PACKAGE_NAME-1 skipped."
else
  echo "$MAKE_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $MAKE_PACKAGE_NAME-1
  ./configure --prefix=/usr --without-guile --host=$TC_TGT --build=$(build-aux/config.guess)
  make
  make DESTDIR=$TC install
  cd $TC/sources
  echo "$MAKE_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making patch
if grep -Fxq "$PATCH_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$PATCH_PACKAGE_NAME-1 skipped."
else
  echo "$PATCH_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $PATCH_PACKAGE_NAME-1
  ./configure --prefix=/usr --host=$TC_TGT --build=$(build-aux/config.guess)
  make
  make DESTDIR=$TC install
  cd $TC/sources
  echo "$PATCH_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making sed
if grep -Fxq "$SED_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$SED_PACKAGE_NAME-1 skipped."
else
  echo "$SED_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $SED_PACKAGE_NAME-1
  ./configure --prefix=/usr --host=$TC_TGT --build=$(./build-aux/config.guess)
  make
  make DESTDIR=$TC install
  cd $TC/sources
  echo "$SED_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making tar
if grep -Fxq "$TAR_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$TAR_PACKAGE_NAME-1 skipped."
else
  echo "$TAR_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $TAR_PACKAGE_NAME-1
  ./configure --prefix=/usr --host=$TC_TGT --build=$(build-aux/config.guess)
  make
  make DESTDIR=$TC install
  cd $TC/sources
  echo "$TAR_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making xz
if grep -Fxq "$XZ_PACKAGE_NAME-1-success" compile_sequence_history.txt; then
  echo "$XZ_PACKAGE_NAME-1 skipped."
else
  echo "$XZ_PACKAGE_NAME-1-started" | tee -a compile_sequence_history.txt
  cd $XZ_PACKAGE_NAME-1
  ./configure --prefix=/usr --host=$TC_TGT --build=$(build-aux/config.guess) --disable-static --docdir=/usr/share/doc/$XZ_PACKAGE_NAME
  make
  make DESTDIR=$TC install
  rm -v $TC/usr/lib/liblzma.la
  cd $TC/sources
  echo "$XZ_PACKAGE_NAME-1-success" | tee -a compile_sequence_history.txt
fi
# Making binutils. 2nd time?
if grep -Fxq "$BINUTILS_PACKAGE_NAME-2-success" compile_sequence_history.txt; then
  echo "$BINUTILS_PACKAGE_NAME-2 skipped."
else
  echo "$BINUTILS_PACKAGE_NAME-2-started" | tee -a compile_sequence_history.txt
  cd $BINUTILS_PACKAGE_NAME-2
  # linic - $BINUTILS_PACKAGE_NAME-upstream_fix-1.patch not used?
  mkdir build
  cd build
  if ../configure --prefix=/usr --build=$(../config.guess) --host=$TC_TGT --disable-nls --enable-shared --enable-gprofng=no --disable-werror --enable-64-bit-bfd --enable-new-dtags --enable-default-hash-style=gnu; then
    make
    make DESTDIR=$TC install
    # linic - this fails so I replaced it with a loop that checks if the file exists.
    # rm -v $TC/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
    # linic - I think brace expansion does not work in my case. I replaced it with a POSIX-compilant way
    for file in \
      "$TC/usr/lib/libbfd.a" "$TC/usr/lib/libbfd.la" \
      "$TC/usr/lib/libctf.a" "$TC/usr/lib/libctf.la" \
      "$TC/usr/lib/libctf-nobfd.a" "$TC/usr/lib/libctf-nobfd.la" \
      "$TC/usr/lib/libopcodes.a" "$TC/usr/lib/libopcodes.la" \
      "$TC/usr/lib/libsframe.a" "$TC/usr/lib/libsframe.la"
    do
      [ -e "$file" ] && rm -v "$file"
    done
    cd $TC/sources
    echo "$BINUTILS_PACKAGE_NAME-2-success" | tee -a compile_sequence_history.txt
  else
    echo "$BINUTILS_PACKAGE_NAME-2 failed!"
    exit 24312
  fi
fi
# Making gcc. 2nd time, but this is the 3rd time using the $GCC_PACKAGE_NAME sources. Different parameters to the configure.
if grep -Fxq "$GCC_PACKAGE_NAME-3-success" compile_sequence_history.txt; then
  echo "$GCC_PACKAGE_NAME-3 skipped."
else
  echo "$GCC_PACKAGE_NAME-3-started" | tee -a compile_sequence_history.txt
  cd $GCC_PACKAGE_NAME-3
  mkdir build
  cd build
  ../configure --build=$(../config.guess) --host=$TC_TGT --target=$TC_TGT LDFLAGS_FOR_TARGET=-L$PWD/$TC_TGT/libgcc --prefix=/usr --with-build-sysroot=$TC --enable-default-pie --enable-default-ssp --disable-nls --disable-multilib --disable-libatomic --disable-libgomp --disable-libquadmath --disable-libsanitizer --disable-libssp --disable-libvtv --enable-languages=c,c++
  make
  make DESTDIR=$TC install
  ln -sv gcc $TC/usr/bin/cc
  cd $TC/sources
  echo "$GCC_PACKAGE_NAME-3-success" | tee -a compile_sequence_history.txt
fi

echo "compile-tinycore-sources-within-host.sh has completed. The next script to run is prepare-chroot-part1.sh. Do you want to run it now? (y/n)"
read continue_y_n
if [ $continue_y_n = "y" ]; then
  $TC/tcc/prepare-chroot-part1.sh
fi
