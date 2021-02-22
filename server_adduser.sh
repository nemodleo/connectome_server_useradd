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
adduser -c $name --conf /etc/connectome/adduser.conf --uid $uid $userid

# adduser in other nodes
nodes="master node1 node2"
for node in $nodes; do 
ssh -T -A conmaster@$node << EOF
bash
adduser -c $name --conf /etc/connectome/adduser.conf --uid $uid $userid
cat << DOCKERFILE > /home/connectome/$userid/docker/Dockerfile
FROM pytorch/pytorch #

RUN apt-get update && \
    apt-get -y install sudo 
    
RUN pip3 install --upgrade pip3
RUN pip3 install jupyter

RUN groupadd -g 10000 connectome
RUN useradd -m -u $uid -g 10000 $userid
RUN passwd -d $userid
RUN usermod -G sudo $userid

EXPOSE $uid
EXPOSE 8888
USER $userid

###

# If you need other operation, write down on this part!











###

DOCKERFILE
chown -R $userid:connectome /home/connectome/$userid/docker/Dockerfile
EOF
done
ssh -T -A conmaster@storage << EOF
bash
adduser -c $name --conf /etc/connectome/adduser.conf --uid $uid $userid
mkdir - /data/connectome/$userid
chown -R $userid:connectome /data/connectome/$userid
EOF

