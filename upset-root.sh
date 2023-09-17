#!/usr/bin/bash -ex
## upset-root.sh

id

passwd

dnf install git

mount /dev/sdc3 /run/media/root/29_Mar_2023

pushd /run/media/root/29_Mar_2023/set-up-git.sh

rsync -ca ./.gnupg ./.ssh ./.mozilla ./.angband /home/liveuser 
rsync -ca ./.config/gh /home/liveuser/.config
rsync -ca ./.toprc_liveuser /home/liveuser/.config/procps/toprc
rsync -ca ./.vimrc_liveuser /home/liveuser/.vimrc

popd

umount /dev/sdc3

