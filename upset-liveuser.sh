#!/usr/bin/bash -ex
## upset-liveuser.sh

passwd

pushd /boot

test -x ./upset-root.sh

sudo ./upset-root.sh

pushd /home/liveuser

mkdir ./MYPROJECTS

pushd ./MYPROJECTS

git clone https://github.com/wileyhy/LiveUsb

pushd ./LiveUsb


