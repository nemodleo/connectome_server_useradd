# prepared env #this part need to exec only 1!
# ./server_adduser_etc.sh 

sudoPW=$1
nodes=(master node1 node2 storage)

for node in ${nodes[@]} 
do
	scp -r /etc/connectome conmaster@$node:~/server_management/connectome
	ssh -A -T $node <<-EOF
	sudo -S rm -rf /etc/connectome
	sudo -S mkdir /etc/connectome
	sudo -S mv ~/server_management/connectome /etc
	sudo -S chown -R root:root /etc/connectome
	rm -rf ~/server_management/connectome
	EOF
done
