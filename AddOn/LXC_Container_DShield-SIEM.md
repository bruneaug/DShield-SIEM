# Proxmox Setup DShield SIEM with LXC Container

In Proxmox server, select local and download the Ubuntu 24.04 template:<br>
Download and install Ubuntu 24.04<br>
Configure and install Ubuntu 24.04 Container<br>

Minimum Installation <br>
8 - 12 GB RAM<br>
350 GB<br>

adduser guy<br>
passwd guy<br>
vi /etc/group -> add user to sudo:x:27:guy<br>
Login with user guy<br>

sudo apt-get upgrade<br>
sudo apt-get update<br>
sudo apt-get install htop net-tools lxc<br>

Login as root in Proxmox server and add the following 2 lines to the LXC container config (mine is 101):<br>

vi /etc/pve/lxc/101.conf<br>
ls -l /var/lib/lxc/101<br>

lxc.prlimit.memlock=-1<br>
lxc.prlimit.nofile:65536<br>

Those 2 additional configuration are used by ELK server es01 to start.<br>
Shutdown and take a snapshot<br>

## Adding Partition /var/lib/docker
Goto Resources -> Add -> Mount Point -> Create: Mount Point<br>
Configure as follow and **unselect Backup:**<br>
![image](https://github.com/user-attachments/assets/9790d733-52b4-4992-bf9b-53493098c2b1)

Restart sensor to apply changes <br>
Login and check the server and it should show 2 partitions:<br>
![image](https://github.com/user-attachments/assets/02caaab6-6d08-495c-a992-577e21875e0e)

Now proceed to install DShield SIEM<br>

https://github.com/bruneaug/DShield-SIEM/blob/main/README.md
