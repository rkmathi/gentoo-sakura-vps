#!/bin/bash

BROOT=${BROOT-/mnt/livecd/root}
SCRIPTSDIR=$(cd $(dirname $0); cd ../; pwd)
GENTOO_MIRROR=$(bash ${SCRIPTSDIR}/scripts/bootstrap-misc-mirror.sh)

### bug #275555
## Ask for the new root password
#trap 'stty echo' INT
#stty -echo
#echo -n "New root password: "
#read PASSWD1
#echo ""
#echo -n "New root password (again): "
#read PASSWD2
#echo ""
#stty echo
#trap INT
#
#if [ "${PASSWD1}" != "${PASSWD2}" ]
#then
#	echo "Password mismatch."
#	exit
#fi

## Configuring your network

ifconfig eth0 $(cat ${BROOT}/netconfig/addr.txt) \
    netmask $(cat ${BROOT}/netconfig/mask.txt) \
    broadcast $(cat ${BROOT}/netconfig/bcast.txt) up

route add default gw $(cat ${BROOT}/netconfig/gw.txt)

for ip in $(cat ${BROOT}/netconfig/resolv.txt)
do
    echo "nameserver ${ip}" >> /etc/resolv.conf
done

## Preparing the Disks

mkfs.ext4 /dev/vda3
mount /dev/vda3 /mnt/gentoo
mkdir -p /mnt/gentoo/boot
mke2fs /dev/vda1
mount /dev/vda1 /mnt/gentoo/boot

## Preparing the swap file
#cd /mnt/gentoo
#dd if=/dev/zero of=swap.img bs=1024K count=128
#mkswap swap.img
#swapon swap.img

## Installing the Gentoo Installation Files

cd /mnt/gentoo

wget $(wget -q -O - ${GENTOO_MIRROR}/releases/amd64/autobuilds/current-stage3/ | \
    egrep -o "(https?|ftp)://[^\"]+/stage3[^.]+\.tar\.bz2" | head -n 1)
tar xvjpf stage3-*.tar.bz2

wget $(wget -q -O - ${GENTOO_MIRROR}/snapshots/ | \
    egrep -o "(https?|ftp)://[^\"]+/portage-latest\.tar\.bz2" | head -n 1)
tar xvjf portage-latest.tar.bz2 -C /mnt/gentoo/usr

cat > /mnt/gentoo/etc/make.conf <<EOM
# For Gentoo/Linux on Sakura VPS(v3) 2G
CFLAGS="-march=nocona -O3 -pipe"
CXXFLAGS="${CFLAGS}"
CHOST="x86_64-pc-linux-gnu"
MAKEOPTS="-j4"

USE="-bluetooth -cups -gnome -gtk -ldap -kde -qt3 -qt4 -x264 \
apache2 bzip2 cddb cgi cjk cvs crypt curl cxx dbus \
fastcgi ftp gd gif gnutils gsl gzip iconv imagemagick imap \
java javascript latex ldap mime mmx mysql \
nas nls ocaml perl php png posix python raw readline \
source sqlite sse sse2 ssl svg syslog udev unicode \
vim-syntax xml zlib zsh-completion"

LINGUAS="en"

GENTOO_MIRRORS="http://ftp.iij.ad.jp/pub/linux/gentoo/"
SYNC="rsync://rsync.jp.gentoo.org/gentoo-portage"
EOM

## Installing the Gentoo Base System

# mirrorselect -i -r -o >> /mnt/gentoo/etc/make.conf
#echo "GENTOO_MIRRORS=\"${GENTOO_MIRROR} \"" >> /mnt/gentoo/etc/make.conf

cp -L /etc/resolv.conf /mnt/gentoo/etc/

mount -t proc none /mnt/gentoo/proc
mount --rbind /dev /mnt/gentoo/dev

# Copy the scripts
cp -r ${SCRIPTSDIR} /mnt/gentoo/root/gentoo-sakura-vps/
cp -r ${BROOT}/netconfig /mnt/gentoo/root/

### bug #275555
#chroot /mnt/gentoo ${SCRIPTSDIR}/scripts/bootstrap-2-chroot.sh ${PASSWD1}
chroot /mnt/gentoo ${SCRIPTSDIR}/scripts/bootstrap-2-chroot.sh

cd
umount -l /mnt/gentoo/boot /mnt/gentoo/dev /mnt/gentoo/proc
#swapoff /mnt/gentoo/swap.img
umount -l /mnt/gentoo

#reboot
