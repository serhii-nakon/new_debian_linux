#!/usr/bin/env bash

LINUX_VERSION=5.16.14

apt update && apt full-upgrade -y && \
apt install build-essential linux-source bc kmod cpio flex bison libelf-dev libssl-dev libncurses5-dev rsync python3 dwarves wget -y && \
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$LINUX_VERSION.tar.xz -P /root && \
tar xfJ /root/linux-$LINUX_VERSION.tar.xz -C /root/build && \
cp -v /root/build/config /root/build/linux-$LINUX_VERSION/.config && \
cd /root/build/linux-$LINUX_VERSION && \
patch -p1 < /root/build/patches/0001-Revert-iwlwifi-remove-lar_disable-module-parameter.patch && \
make -j$(nproc) bindeb-pkg LOCALVERSION=-my KDEB_PKGVERSION=$(make kernelversion)-1 ARCH=x86_64
cd /root/build/ && \
rm -rf /root/build/linux-$LINUX_VERSION && \
echo Complete
