#!/bin/sh
# based on https://forum.tinycorelinux.net/index.php/topic,24244.msg178596.html#msg178596

# example with $BINUTILS_PACKAGE_NAME-4 which happens during compilation based on compile_tc16_x86
  touch $BINUTILS_PACKAGE_NAME-4-time-marker
  LD_PRELOAD=/sources/uname_hack.so make tooldir=/usr/local install
  echo "[remove binutils from /usr]"
  if [ ! -f binutils_usr.tce.list ]; then
    touch $BINUTILS_PACKAGE_NAME-4.candidates.files
    echo "remove-binutils-from/usr" >> $BINUTILS_PACKAGE_NAME-4.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $BINUTILS_PACKAGE_NAME-4.candidates.files
    find / -not -type 'd' -cnewer $BINUTILS_PACKAGE_NAME-4-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $BINUTILS_PACKAGE_NAME-4.candidates.files
    vi $BINUTILS_PACKAGE_NAME-4.candidates.files
    mv $BINUTILS_PACKAGE_NAME-4.candidates.files binutils_usr.tce.list
  fi
  for file in `cat binutils_usr.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done

# example with $GCC_PACKAGE_NAME-4 which happens during compilation based on compile_tc16_x86
  touch $GCC_PACKAGE_NAME-4-time-marker
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "[remove gcc from /usr except libstdc++ and libgcc_s]"
  if [ ! -f gcc_usr_local_remove.tce.list ]; then
    touch $GCC_PACKAGE_NAME-4.candidates.files
    echo "remove-gcc-from/usr-except-libstdc++-and-libgcc_s" >> $GCC_PACKAGE_NAME-4.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $GCC_PACKAGE_NAME-4.candidates.files
    find / -not -type 'd' -cnewer $GCC_PACKAGE_NAME-4-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $GCC_PACKAGE_NAME-4.candidates.files
    vi $GCC_PACKAGE_NAME-4.candidates.files
    mv $GCC_PACKAGE_NAME-4.candidates.files gcc_usr_local_remove.tce.list
  fi
  for file in `cat gcc_usr_local_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done

# example with $NCURSES_PACKAGE_NAME-2 which happens during compilation based on compile_tc16_x86
  touch $NCURSES_PACKAGE_NAME-2-time-marker
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "[remove ncurses from /usr]"
  if [ ! -f ncurses_usr_remove.tce.list ]; then
    touch $NCURSES_PACKAGE_NAME-2.candidates.files
    echo "remove-ncurses-from/usr" >> $NCURSES_PACKAGE_NAME-2.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $NCURSES_PACKAGE_NAME-2.candidates.files
    find / -not -type 'd' -cnewer $NCURSES_PACKAGE_NAME-2-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $NCURSES_PACKAGE_NAME-2.candidates.files
    vi $NCURSES_PACKAGE_NAME-2.candidates.files
    mv $NCURSES_PACKAGE_NAME-2.candidates.files ncurses_usr_remove.tce.list
  fi
  for file in `cat ncurses_usr_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done

# example with $BISON_PACKAGE_NAME-2 which happens during compilation based on compile_tc16_x86
  touch $BISON_PACKAGE_NAME-2-time-marker
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "[remove bison from /usr]"
  if [ ! -f bison_usr_remove.tce.list ]; then
    touch $BISON_PACKAGE_NAME-2.candidates.files
    echo "remove-bison-from/usr" >> $BISON_PACKAGE_NAME-2.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $BISON_PACKAGE_NAME-2.candidates.files
    find / -not -type 'd' -cnewer $BISON_PACKAGE_NAME-2-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $BISON_PACKAGE_NAME-2.candidates.files
    vi $BISON_PACKAGE_NAME-2.candidates.files
    mv $BISON_PACKAGE_NAME-2.candidates.files bison_usr_remove.tce.list
  fi
  for file in `cat bison_usr_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done

# example with $GREP_PACKAGE_NAME-2 which happens during compilation based on compile_tc16_x86
  touch $GREP_PACKAGE_NAME-2-time-marker
  LD_PRELOAD=/sources/uname_hack.so make install
  echo "[remove grep from /usr/bin]"
  if [ ! -f grep_usr_bin_remove.tce.list ]; then
    touch $GREP_PACKAGE_NAME-2.candidates.files
    echo "remove-grep-from/usr/bin" >> $GREP_PACKAGE_NAME-2.candidates.files
    echo "remove-any-obviously-unneeded-files-and-lines-like-this-one" >> $GREP_PACKAGE_NAME-2.candidates.files
    find / -not -type 'd' -cnewer $GREP_PACKAGE_NAME-2-time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $GREP_PACKAGE_NAME-2.candidates.files
    vi $GREP_PACKAGE_NAME-2.candidates.files
    mv $GREP_PACKAGE_NAME-2.candidates.files grep_usr_bin_remove.tce.list
  fi
  for file in `cat grep_usr_bin_remove.tce.list`; do [ -e "$file" ] && rm -v "$file" ; done
