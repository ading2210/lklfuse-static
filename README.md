# lklfuse-static

This repository contains scripts for building [`lklfuse`](https://github.com/lkl/linux/blob/master/tools/lkl/lklfuse.c) as a single static binary. The final executable is only 4.1MB in size.

`lklfuse` allows you to mount any filesystem supported by Linux (EXT4, BTRFS, XFS) as a FUSE mount, without needing root. Since `lklfuse` uses the Linux kernel's code directly, there is no need for a virtual machine (which is what `libguestfs` does).

## Building:

1. Run `sudo ./build.sh` as root. This will create an Alpine Linux chroot and run the build.
2. Your static binaries are now located at `./lklfuse` and `./fusermount`. Copy these into `/usr/local/bin`. 
3. Optionally delete the Alpine chroot once you are done with `sudo alpine/destroy --remove`.

## Usage:
Creating and mounting an EXT4 partition on a disk image, without root:
```
$ fallocate -l 512MB /tmp/disk.img
$ mkfs.ext4 /tmp/disk.img
mke2fs 1.47.0 (5-Feb-2023)
Discarding device blocks: done                            
Creating filesystem with 499713 1k blocks and 124928 inodes
Filesystem UUID: 42c0a683-d6e9-49ac-a354-b62793ef670a
Superblock backups stored on blocks: 
        8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done 

$ mkdir /tmp/disk
$ lklfuse /tmp/disk.img /tmp/disk/ -o type=ext4
$ echo "hi" > /tmp/disk/test.txt
$ df -h /tmp/disk
Filesystem      Size  Used Avail Use% Mounted on
lklfuse         448M   15K  419M   1% /tmp/disk
$ umount /tmp/disk
```

## Copyright:
This repository is licensed under the GNU GPL v3.

```
ading2210/lklfuse-static: Scripts to compile lklfuse as a static binary
Copyright (C) 2024 ading2210

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```