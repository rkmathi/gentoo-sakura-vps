#!/bin/bash

rm -f /stage3-*.tar.bz2
rm -f /portage-latest.tar.bz2

#rm -f /swap.img
parted -s /dev/vda mkfs 2 linux-swap
mkswap /dev/vda2
sed -i \
    -e "s:#/dev/vda2:/dev/vda2:" \
        /etc/fstab

rm -f /kernel-version.txt

reboot
