#!/usr/bin/env bash

ROOTAPP=$(dirname $(realpath -s $0))
WHOAMI=$(whoami)
USERID=$(id -u $WHOAMI)
GROUPID=$(id -g $WHOAMI)

CONTAINER_NAME=linux

lxc-stop $CONTAINER_NAME
lxc-destroy $CONTAINER_NAME
cp -v $ROOTAPP/lxc.conf.sample $ROOTAPP/lxc.conf && \
sed -i "s@<PATHTOAPP>@$ROOTAPP@g" $ROOTAPP/lxc.conf && \
sed -i "s@<USERID>@$USERID@g" $ROOTAPP/lxc.conf && \
sed -i "s@<GROUPID>@$GROUPID@g" $ROOTAPP/lxc.conf && \
lxc-create -t download -n $CONTAINER_NAME -f $ROOTAPP/lxc.conf -- -d debian -r bullseye -a amd64 --no-validate && \
rm -fv $ROOTAPP/lxc.conf  && \
lxc-unpriv-start $CONTAINER_NAME && \
sleep 15 && \
lxc-attach $CONTAINER_NAME -- /root/build/build.sh && \
lxc-stop $CONTAINER_NAME
lxc-destroy $CONTAINER_NAME
