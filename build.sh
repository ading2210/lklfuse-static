#!/bin/bash

set -e
set -x

if [ ! -f "linux-master.zip" ]; then
  wget "https://codeload.github.com/lkl/linux/zip/refs/heads/master" -O linux-master.zip
fi

if [ ! -d "linux" ]; then
  unzip -q linux-master.zip
  mv linux-master linux
fi


cd linux/tools/lkl

make all -j$(nproc --all)
mv liblkl.a lib

gcc -static -O3 lklfuse.c -D_FILE_OFFSET_BITS=64 -Llib -Iinclude -llkl -lfuse -o lklfuse
upx -q lklfuse
mv lklfuse ../../../