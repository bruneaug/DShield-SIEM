# Proxmox Setup DShield SIEM with LXC Container

Before starting, you need to decide if you want to use 22.04 or 24.04 template.<br>
For example, if you want to user Arkime, it currently only support 20.04 and 22.04<br>
In Proxmox server, select storage local and download the Ubuntu 22.04 or 24.04 template:<br>
Download and install Ubuntu 22.04 or 24.04<br>
Configure and install Ubuntu 22.04 or 24.04 Container<br>

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
Since the SSH service doesn't always starts, start sshd service<br>
````
systemctl start sshd
systemctl status sshd
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
lxc.prlimit.memlock=-1
lxc.prlimit.nofile:65536
````
Those 2 additional configuration are used by ELK server es01 to start.<br>
Using your user account (i.e. guy), shutdown the new sensor<br>
````
sudo init 0
````

## Adding Partition /var/lib/docker
Goto Resources -> Add -> Mount Point -> Create: Mount Point<br>
Configure as follow and **unselect Backup:**<br>
![image](https://github.com/user-attachments/assets/9790d733-52b4-4992-bf9b-53493098c2b1)

Take a snapshot before restarting the server. If you want to revert, you will have a ready to use image.<br>
Restart sensor to apply changes <br>
Login and check the server and it should show 2 partitions:<br>
![image](https://github.com/user-attachments/assets/2dd26781-b823-4924-9825-df39b7eb97f0)

Now proceed to install DShield SIEM<br>

https://github.com/bruneaug/DShield-SIEM/blob/main/README.md
