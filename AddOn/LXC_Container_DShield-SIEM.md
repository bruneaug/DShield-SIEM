# Proxmox Setup DShield SIEM with LXC Container

In Proxmox server, select local and download the Ubuntu 24.04 template:<br>
Download and install Ubuntu 24.04<br>
Configure and install Ubuntu 24.04 Container<br>

Minimum Installation <br>
RAM 8 - 12 GB<br>
Swap 8192<br>
30 GB main partition<br>
300+ GB Docker partition (will be configured later)<br>

Start LXC and login as root<br>
Add user user account (i.e. adduser guy<br>
Add password to account (i.e.passwd guy)<br>
Edit /etc/group to add user account for sudo access (i.e. sudo:x:27:guy)<br>
````
vi /etc/group
````
Login with user guy<br>
````
sudo apt-get upgrade
sudo apt-get update
sudo apt-get install htop net-tools 
````

Login as root in Proxmox server and add the following 2 lines to the LXC container config (mine is 101):<br>
````
vi /etc/pve/lxc/101.conf
````
Copy this at the bottom of the configuration file<br>
````
lxc.prlimit.memlock=-1<br>
lxc.prlimit.nofile:65536<br>
````
Those 2 additional configuration are used by ELK server es01 to start.<br>
Shutdown and take a snapshot<br>
````
init 0
````

## Adding Partition /var/lib/docker
Goto Resources -> Add -> Mount Point -> Create: Mount Point<br>
Configure as follow and **unselect Backup:**<br>
![image](https://github.com/user-attachments/assets/9790d733-52b4-4992-bf9b-53493098c2b1)

Restart sensor to apply changes <br>
Login and check the server and it should show 2 partitions:<br>
![image](https://github.com/user-attachments/assets/02caaab6-6d08-495c-a992-577e21875e0e)

Now proceed to install DShield SIEM<br>

https://github.com/bruneaug/DShield-SIEM/blob/main/README.md
