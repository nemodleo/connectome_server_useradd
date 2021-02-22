# connectome_server_adduser
This repository is for administrators (conmasters) of the Connetome LAB server.   
This code creates an account belonging to connectome in each server (gateway, master, node1, node2, storage) with the given user ID and UID.   


### Rules for adding users belonging to connectome:   
0. UID: 10000~19999 (ex. 11111)
1. User ID: ct + UID (ex. ct11111)
2. GID: 10000 (connectome group)
3. Home dir: /home/connectome/{User ID}
4. Share dir: /data/connectome/{User ID} (in storage) <-> /Scratch/connectome/{User ID} (in master, node1, node2)


### Prepared (Hyun already do this!)
This script (server_adduser_etc.sh) is written for password input format, not ssh key.   
If you want to convert content of /etc/connectome/, fixed in gateway and run command below.   
~~~Bash
conmaster@gateway:~/server_management$ server_adduser_etc.sh {conmaster passwd}
~~~

For all servers(gateway, master, node1, node2, storage) should satisfy the following dir tree.
~~~Bash
conmaster@gateway:/etc/connectome$ tree -N
.
├── adduser.conf
└── connectome_skel
    └── docker
        ├── Dockerfile
        └── share

3 directories, 2 files
~~~

### Run

~~~Bash
conmaster@gateway:~/server_management$ ./server_adduser.sh {UID} {First_Lastname no middlename}

#example
conmaster@gateway:~/server_management$ ./server_adduser.sh 11111 Hyun_Park
~~~


### Result
