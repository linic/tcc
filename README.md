# tcc
tinycore compiler - set of scripts to semi-automatically build the tinycore sources
The scripts are based on [compile_tc16_x86](http://tinycorelinux.net/16.x/x86/release/src/toolchain/compile_tc16_x86).

## This is not building or compiling from scratch
I was initially looking to build or compile tinycore from scratch. What I found is that's not
really the way new tinycore versions are compiled and released and that's not really what I needed.
For more details, these posts are interesting:
- [building core.gz from scratch](https://forum.tinycorelinux.net/index.php/topic,24244.msg178435.html#msg178435)
- [TinyCore from SCRATCH - NADA -ZILCH - ZIP - NULL - - - THE BIG BANG!!!](https://forum.tinycorelinux.net/index.php/topic,299)
- [cor blimey 357-byte's (Full-Source Bootstrap)](https://forum.tinycorelinux.net/index.php/topic,26272)

In summary, each new tinycore release is built using the previous and replacing `vmlinuz` (aka `bzImage`) and
`core.gz` with updated versions. What's in this repo is a way I use to recompile major "building blocks" which
make `core.gz`. For now, I manually replace the "blocks" within `core.gz` with recompiled ones for
the kernel and/or CPU I want to use. To [manually replace "blocks" within `core.gz` see this post](https://forum.tinycorelinux.net/index.php/topic,24244.msg178436.html#msg178436)

## 4.4.302-cip97
In [scripts/common.sh](./scripts/common.sh),
`ENABLE_KERNEL=4.4.0` is present to allow for any kernel from the 4.4.x line to work. I haven't finished
compiling and testing yet. I tried with 4.4.302, but glibc-2.40 compilation would fail with the message
"kernel headers present are too old" which was strange since the build logs would say the lowest support
kernel is 3.2.0. Using 4.4.0 makes the compilation complete.
I think 4.4.302 might break the version parsing maybe? 4.4.0 works. Since 4.4.302 is later than 4.4.0 and
4.4.0 is later than 3.2.0, this is a good value for now.
See more at [tcl-core-560z](https://github.com/linic/tcl-core-560z)

# The scripts

WORK IN PROGRESS. I haven't used yet [prepare-additional-modifications.sh](./scripts/prepare-additional-modifications.sh)
and [apply-additional-modifications.sh](./scripts/apply-additional-modifications.sh).
I successfully compiled all the sources from [compile_tc16_x86](http://tinycorelinux.net/16.x/x86/release/src/toolchain/compile_tc16_x86)
and [compile_busybox](http://tinycorelinux.net/15.x/x86/release/src/busybox/compile_busybox).
I used TC16 x86 to run these scripts. Read more below. You will have to change some things because you're likely
not targeting 4.4.302-cip97 and the ThinkPad 506z.

## Happy path scripts
When no errors occure in these scripts, .tce.list files are available, run in this sequence.

1. [get-tcc-scripts.sh](./scripts/get-tcc-scripts.sh): get the tcc scripts in /home/tc/tcc/
2. [prepare-compilation.sh](./scripts/prepare-compilation.sh): prepare the directories before starting compilation. The scripts in the subpoints below are called in this order by prepare-compilation.sh. This way saves times and minimizes errors.
2.1. [tce-load-tinycore-sources.sh](./scripts/tce-load-tinycore-sources.sh): download and load the .tcz extensions required to build the tinycore base files.
2.2. [get-tinycore-sources.sh](./scripts/get-tinycore-sources.sh): download the sources to compile the base files. Download patches and other scripts which are hosted on a server (manually setup; setup of that server is out of scope). This script could be modified to get the files from github. This script gets the files in the [sources](./sources) which are files I created either because I preferred to have files or because some files were needed to fill in gaps in [compile_tc16_x86](http://tinycorelinux.net/16.x/x86/release/src/toolchain/compile_tc16_x86).
2.3. [extract-tinycore-sources.sh](./scripts/extract-tinycore-sources.sh): this is called by `prepare-compilation.sh` extract the sources. sometimes multiple times because they'll be compiled more than once.
2.4. [patch-tinycore-sources.sh](./scripts/patch-tinycore-sources.sh): this is called by `prepare-compilation.sh` patch the tinycore sources.
3. [compile-tinycore-sources-within-host.sh](./scripts/compile-tinycore-sources-within-host.sh): first compilation script. /dev/sdb1 may need to be modified according to your environment. It creates the `/mnt/tc` and sets that as the `TC` variable. This directory is the base of the chroot compilation which follows.
4. [prepare-chroot-part1.sh](./scripts/prepare-chroot-part1.sh): first part of the preparation of a chroot environment and logs in as root.
5. [prepare-chroot-part2.sh](./scripts/prepare-chroot-part2.sh): completes the preparation of a chroot environment and switches to it.
6. [compile-tinycore-sources-within-chroot-part1.sh](compile-tinycore-sources-within-chroot-part1.sh): continue the compilation within the chroot environment until the exec call after bash has been compiled.
7. [compile-tinycore-sources-within-chroot-part2.sh](compile-tinycore-sources-within-chroot-part2.sh): continue the compilation within the chroot environment.
8. [compile-busybox.sh](./scripts/compile-busybox.sh): compile busybox which will be compatible with the 4.4.302 kernel and without code for i486
9. [prepare-additional-modifications.sh](./scripts/prepare-additional-modifications.sh): .tce.list files and some modifications to files which need to be done manually the first time.
10. [apply-additional-modifications.sh](./scripts/apply-additional-modifications.sh): apply what has been prepared at the previous step
11. Manually replace the base files in the rootfs.gz.

## Fallback scripts
When there are errors or missing .tce.list files, use these scripts to help fix the issues and then get back to the happy path.
Also, the compilation process is long so you might want to do some of it one day, shutdown your computer and some more another day.

- [reenter-host-compilation-environment.sh](./scripts/reenter-host-compilation-environment.sh)
- [reenter-chroot-part1.sh](./scripts/reenter-chroot-part1.sh)
- [reenter-chroot-part2.sh](./scripts/reenter-chroot-part2.sh)

## Some more notes about the scripts
I added `--disable-lsfd --without-bpf --without-lsfd` when compiling util-linux because the compilation would
fail refering to bpf.h not being present. This is likely because I
unselected lots of things about packet filtering, NFS, CIFS and Samba in my custom .config-v4.x AND because I'm
using a kernel from the 4.4 line and it looks like bpf wasn't (fully?) there yet. You may
be able to use the original commands if you use a more recent kernel.

I changed i486 to i686 (`--march` and aslo `TC_TGT`). `TC_TGT` is in [./sources/.bashrc](./sources/.bashrc).
`MARCH` is defined in [common.sh](./scripts/common.sh)

# The sources
Most sources will be downloaded from the previous scripts. I made some more in [sources](./sources/) to fill
some gaps in [compile_tc16_x86](http://tinycorelinux.net/16.x/x86/release/src/toolchain/compile_tc16_x86) and
to account for the fact that I'm trying to use this with a very custom 4.4.302-cip97 kernel. You'll find the
.config-v4.x for this kernel at [tcl-core-560z](https://github.com/linic/tcl-core-560z).

About [busybox-1.36.1_config_suid-560z](./sources/busybox-1.36.1_config_suid-560z), this is likely because I
unselected lots of things about packet filtering, NFS, CIFS and Samba in my custom .config-v4.x. You may
be able to use the original suid file hosted on tinycore if you also use the .config for kernels from there.

# Using the scripts and the sources

## virtualbox method
1. Create a new VM with the newest official tinycore image.
2. Run the frugal installation.
3. `sudo reboot` and modify `extlinux.conf` to load home and opt from the drive too.
4. Take a snapshot.
5. Create another drive and format it as ext4

### Create another drive and format it as ext4
```
sudo fdisk -l
sudo fdisk /dev/sdb
o
n
p
1
<press enter to use the default starting sector>
<press enter to use the default end sector>
w
sudo mkfs.ext4 /dev/sdb1
```

## Troubleshooting compilation
### Useful commands
`grep -A 20 "checking whether the C compiler works" config.log` when a configure fails with this error this will give more details.
`find /usr -name cc1` when something is missing from the C compiler works check, this can find it.

### Troubleshooting m4 compilation
Missing files
Scrt1.o crti.o -lc crtn.o
I fixed that one by adding set -e and trap and removing everything in my /dev/sdb1/ and starting from the begginning.

# Bonus
## vim
## useful to create the variables in scripts/common.sh
`%s/\<\([a-z]\+\)_/\U\1_/g` capitalize the first word before an _
`%s/\.tar[^"]*//g` removes the `.tar*`
