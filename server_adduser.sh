#!/bin/bash

uid=$1
name_raw=$2
sudoPW=$3

userid=ct$uid
name=$(echo $name_raw | cut -f 1 -d"_")" "$(echo $name_raw | cut -f 2 -d"_")

# adduser in gateway
echo $sudoPW | sudo -S adduser -c $name --conf /etc/connectome/adduser.conf --uid $uid --disabled-password $userid

# adduser in other nodes
nodes="master node1 node2"
for node in $nodes; do 
sshpass -p $sudoPW ssh -T -A conmaster@$node << EOF
bash
echo $sudoPW | sudo -S adduser -c $name --conf /etc/connectome/adduser.conf --uid $uid --disabled-password $userid
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
echo $sudoPW | sudo -S chown -R $userid:connectome /home/connectome/$userid/docker/Dockerfile
EOF
done
sshpass -p $sudoPW ssh -T -A conmaster@storage << EOF
bash
echo $sudoPW | sudo -S adduser -c $name --conf /etc/connectome/adduser.conf --uid $uid --disabled-password $userid
echo $sudoPW | sudo -S mkdir - /data/connectome/$userid
echo $sudoPW | sudo -S chown -R $userid:connectome /data/connectome/$userid
EOF

