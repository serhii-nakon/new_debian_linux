#!/usr/bin/env bash

set -e

LINUX_VERSION=6.2.10

apt update
apt full-upgrade -y

apt install build-essential linux-source bc kmod cpio flex bison libelf-dev libssl-dev libncurses5-dev rsync python3 dwarves wget git -y

cd /root/build
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$LINUX_VERSION.tar.xz -O - | tar xJ

cp -v /root/build/config /root/build/linux-$LINUX_VERSION/.config
cd /root/build/linux-$LINUX_VERSION
make oldconfig
scripts/config --disable SECURITY_LOCKDOWN_LSM
scripts/config --disable MODULE_SIG
make -j$(nproc) bindeb-pkg LOCALVERSION=-my KDEB_PKGVERSION=$(make kernelversion)-1 ARCH=x86_64
cd /root/build/
rm -rf /root/build/linux-$LINUX_VERSION
echo Complete
