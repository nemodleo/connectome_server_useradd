# connectome_server_adduser
This repository is for administrators (conmasters) of the Connetome LAB server.   
This code creates an account belonging to connectome in each server (gateway, master, node1, node2, storage) with the given user ID and UID.   
** I haven't checked it yet.

### Rules for adding users belonging to connectome:   
1. User ID: ct + 10000~19999 (ex. ct11111)
2. GID: 10000 (connectome group)
3. Home dir: /home/connectome/{User ID}
4. Share dir: /data/connectome/{userid} (in storage) <-> /Scratch/connectome/{userid} (in master, node1, node2)



### Auto Prepared (You Do Not Touch This!)
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
conmaster@gateway:~/server_management$ ./server_adduser.sh {userid} {GID} {First_Lastname no middlename}

#example
conmaster@gateway:~/server_management$ ./server_adduser.sh ct11111 11111 Hyun_Park
~~~


### Result
