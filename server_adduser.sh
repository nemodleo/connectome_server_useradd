#!/bin/bash

uid=$1
name_raw=$2

userid=ct$uid
name=$(echo $name_raw | cut -f 1 -d"_")" "$(echo $name_raw | cut -f 2 -d"_")


# prepared env #this part need to exec only 1! -> comment!!
#nodes=(master node1 node2 storage)
#for node in ${nodes[@]} 
#do
#	ssh -A $node "echo '/etc/connectome' | sudo tee /etc"
#done


# adduser in gateway
adduser -c "$name" --conf /etc/connectome/adduser.conf --uid $uid $userid

# adduser in other nodes
nodes="master node1 node2"
for node in $nodes; do 
ssh -T -A conmaster@$node << EOF
bash
adduser -c "$name" --conf /etc/connectome/adduser.conf --uid $uid $userid
EOF
done
ssh -T -A conmaster@storage << EOF
bash
adduser -c "$name" --conf /etc/connectome/adduser.conf --uid $uid $userid
mkdir - /data/connectome/$userid
chown -R $userid:connectome /data/connectome/$userid
EOF
