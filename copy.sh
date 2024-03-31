#!/bin/sh

set -e
cp -rv /root/build/*.deb /root/out
cp -rv /root/build/linux-$LINUX_VERSION/.config /root/out/config