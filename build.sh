#!/usr/bin/env bash

set -e

LINUX_VERSION=5.18.3

apt update
apt full-upgrade -y

apt install build-essential linux-source bc kmod cpio flex bison libelf-dev libssl-dev libncurses5-dev rsync python3 dwarves wget git -y

cd /tmp
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
rm -rf /lib/firmware
mv /tmp/linux-firmware /lib/firmware

cd /root/build
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$LINUX_VERSION.tar.xz -O - | tar xJ

cp -v /root/build/config /root/build/linux-$LINUX_VERSION/.config
cd /root/build/linux-$LINUX_VERSION
patch -p1 < /root/build/patches/0001-Revert-iwlwifi-remove-lar_disable-module-parameter.patch
make -j$(nproc) bindeb-pkg LOCALVERSION=-my KDEB_PKGVERSION=$(make kernelversion)-1 ARCH=x86_64
cd /root/build/
rm -rf /root/build/linux-$LINUX_VERSION
echo Complete
