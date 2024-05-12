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

if [ ! "$(cat include/lkl.h | grep "sys/types.h" )" ]; then
  sed -i '1s/^/#include <sys\/types.h>\n/' include/lkl.h
fi

#disable problematic files - these refuse to compile in alpine 
sed -i '/progs-y += tests\/test-dlmopen/d' Targets
sed -i '/hijack/d' Targets

make all -j$(nproc --all)
mv liblkl.a lib

gcc -static -O3 -s -flto lklfuse.c -D_FILE_OFFSET_BITS=64 -Llib -Iinclude -llkl -lfuse -o lklfuse
upx -q lklfuse
cp lklfuse ../../../