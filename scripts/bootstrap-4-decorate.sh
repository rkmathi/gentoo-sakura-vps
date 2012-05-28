#!/bin/bash

emerge --update --deep --newuse --quiet --with-bdeps=y @world

emerge sudo --quiet
sed -i \
    -e 's|^# \(%wheel ALL=(ALL) ALL\)|\1|' \
    /etc/sudoers

sed -i \
    -e "s|^#ChallengeResponseAuthentication yes|ChallengeResponseAuthentication no|" \
    /etc/ssh/sshd_config
/etc/init.d/sshd restart
