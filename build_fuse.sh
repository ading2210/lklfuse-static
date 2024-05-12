#!/bin/bash

set -e
set -x

if [ ! -f "libfuse-master.zip" ]; then
  wget "https://github.com/libfuse/libfuse/archive/refs/heads/master.zip" -O libfuse-master.zip
fi

if [ ! -d "libfuse" ]; then
  unzip -q libfuse-master.zip
  mv libfuse-master libfuse
fi

cd libfuse
mkdir -p build
cd build
meson setup ..
meson configure --default-library static \
  -D buildtype=release \
  -D prefer_static=true \
  -D c_link_args="-static -s -flto" \
  -D cpp_link_args="-static -s -flto" 
ninja

cp util/fusermount3 ../../