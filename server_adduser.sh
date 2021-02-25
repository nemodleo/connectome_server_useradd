#!/bin/bash
userid=$1
uid=$2
name=$3
sudoPW=$4

# adduser in gateway
echo $sudoPW | sudo -S adduser --conf /etc/connectome/adduser.conf --uid $uid --disabled-password --gecos "" $userid
echo $sudoPW | sudo -S usermod -c "$name" $userid
echo $sudoPW | sudo -S passwd -d $userid
echo $sudoPW | sudo -S usermod -aG docker $userid

# adduser in other nodes
nodes="master node1 node2"
for node in $nodes; do 
sshpass -p $sudoPW ssh -T -A conmaster@$node << EOF
bash
echo $sudoPW | sudo -S adduser --conf /etc/connectome/adduser.conf --uid $uid --disabled-password --gecos "" $userid
echo $sudoPW | sudo -S usermod -c "$name" $userid
echo $sudoPW | sudo -S passwd -d $userid
echo $sudoPW | sudo -S usermod -aG docker $userid
EOF
done
sshpass -p $sudoPW ssh -T -A conmaster@storage << EOF
bash
echo $sudoPW | sudo -S adduser --conf /etc/connectome/adduser.conf --uid $uid --disabled-password --gecos "" $userid
echo $sudoPW | sudo -S usermod -c "$name" $userid
echo $sudoPW | sudo -S passwd -d $userid
echo $sudoPW | sudo -S mkdir -p /data/connectome/$userid
echo $sudoPW | sudo -S chown -R $userid:connectome /data/connectome/$userid
EOF

