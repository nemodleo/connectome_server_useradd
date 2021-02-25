#!/bin/bash
userid=$1
uid=$2
name=$3

# adduser in gateway
sudo -S adduser --conf /etc/connectome/adduser.conf --uid $uid --disabled-password --gecos "" $userid
sudo -S usermod -c "$name" $userid
sudo -S passwd -d $userid
sudo -S usermod -aG docker $userid

# adduser in other nodes
nodes="master node1 node2"
for node in $nodes; do 
ssh -T -A conmaster@$node <<-EOF
  bash
  sudo -S adduser --conf /etc/connectome/adduser.conf --uid $uid --disabled-password --gecos "" $userid
  sudo -S usermod -c "$name" $userid
  sudo -S passwd -d $userid
  sudo -S usermod -aG docker $userid
EOF
done
ssh -T -A conmaster@storage <<-EOF
bash
  sudo -S adduser --conf /etc/connectome/adduser.conf --uid $uid --disabled-password --gecos "" $userid
  sudo -S usermod -c "$name" $userid
  sudo -S passwd -d $userid
  sudo -S mkdir -p /data/connectome/$userid
  sudo -S chown -R $userid:connectome /data/connectome/$userid
EOF
