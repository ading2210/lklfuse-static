#!/bin/bash

set -e
set -x

if [ "$EUID" -ne 0 ]; then 
  echo "this needs to be run as root"
  exit 1
fi

alpine_script_url="https://raw.githubusercontent.com/alpinelinux/alpine-chroot-install/master/alpine-chroot-install"
if [ ! -f "alpine-chroot-install" ]; then
  wget "$alpine_script_url" -O alpine-chroot-install
  chmod +x ./alpine-chroot-install
fi

if [ ! -d "alpine" ]; then
  mkdir -p alpine
  chroot_dir="$(realpath alpine)"
  ./alpine-chroot-install -d "$chroot_dir" -p "bash wget unzip flex bison upx python3 make gcc libc-dev fuse-static fuse-dev meson linux-headers"
  alpine/enter-chroot apk add --no-cache --update --repository=https://dl-cdn.alpinelinux.org/alpine/v3.16/main/ libexecinfo-dev
fi

alpine/enter-chroot ./build_lkl.sh
alpine/enter-chroot ./build_fuse.sh