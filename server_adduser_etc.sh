# prepared env #this part need to exec only 1!
# ./server_adduser_etc.sh *******(passwd)

sudoPW=$1
nodes=(master node1 node2 storage)
for node in ${nodes[@]} 
do
	sshpass -p $sudoPW scp -r /etc/connectome conmaster@$node:~/server_management/connectome
	sshpass -p $sudoPW  ssh -A -T $node <<-EOF
	echo $sudoPW | sudo -S rm -rf /etc/connectome
	echo $sudoPW | sudo -S mkdir /etc/connectome
	echo $sudoPW | sudo -S mv ~/server_management/connectome /etc
	echo $sudoPW | sudo -S chown -R root:root /etc/connectome
	rm -rf ~/server_management/connectome
	EOF
done
