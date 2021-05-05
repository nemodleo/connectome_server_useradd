#!/bin/bash
userid=$1
uid=$2
name=$3

# adduser in gateway
sudo -S adduser --conf /etc/connectome/adduser.conf --uid $uid --disabled-password --gecos "" $userid
sudo -S usermod -c "$name" $userid
sudo -S sudo chpasswd <<<"$userid:$userid"
sudo -S usermod -aG docker $userid
