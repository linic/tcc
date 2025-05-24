set +h
umask 022
TC=/mnt/tc
LC_ALL=POSIX
TC_TGT=i686-tc-linux-gnu
PATH=$TC/tools/bin:/usr/local/bin:/bin:/usr/bin
export TC LC_ALL TC_TGT PATH
