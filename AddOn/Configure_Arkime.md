# Setup Arkime with DShield-SIEM

### Latest release version 5.6.1 -> 10 February 2025<br>

This is the steps necessary to install Arkime [1] to parse and index the daemonlogger logs captured by the DShield sensor with Ubuntu 22.04.<br>
First step is to add the IP of your ELK server to the /etc/hosts file following the example below.<br>
````
sudo su -
vi /etc/hosts
````
Add es01 to IP address if doesn't already exists. It should have been added during the installation<br>
192.168.25.231 es01<br>
exit<br>

# Download & Install Arkime

This installation is only for Ubuntu 20.04<br>
````
cd
mkdir arkime
cd arkime
wget https://github.com/arkime/arkime/releases/download/v5.6.1/arkime_5.6.1-1.ubuntu2204_amd64.deb
sudo apt-get install ./arkime_5.6.1-1.ubuntu2204_amd64.deb
````
## Need to Reapply --insecure to Configuration Scripts

Go to this section to reapply --insecure<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/AddOn/Configure_Arkime.md#edit-and-add---insecure-to-configuration-scripts

# Configure Arkime
The bolded data is the sugest configuration. The default password (student) is the password for Arkime to login ELK.<br>
Use what you configure in .env if it is different than student.<br>

$ sudo /opt/arkime/bin/Configure<br>

Found interfaces: br-e4754292a395;docker0;ens160;lo;veth163b883;veth2e92487;veth3e371fe;vethee3c267<br>
Semicolon ';' seperated list of interfaces to monitor [eth1] **lo**<br>
Install Elasticsearch server locally for demo, must have at least 3G of memory, NOT recommended for production use (yes or no) [**no**]<br>
OpenSearch/Elasticsearch server URL [https://localhost:9200] https://es01:9200<br>
OpenSearch/Elasticsearch user [empty is no user] **elastic** <br>
OpenSearch/Elasticsearch password [empty is no password] **student**<br>
Password to encrypt S2S and other things, don't use spaces [must create one] **dshieldlogs** <br>
 
Arkime - Creating configuration files<br>

Installing sample /opt/arkime/etc/config.ini<br>

Arkime - Installing /etc/security/limits.d/99-arkime.conf to make core and memlock unlimited<br>
Download GEO files? You'll need a MaxMind account https://arkime.com/faq#maxmind (yes or no) [**yes**]<br>
Arkime - Downloading GEO files<br>
2025-02-24 22:28:20 URL:https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv [23323/23323] -> "/tmp/tmp.6m3dNzyHi5" [1]<br>
2025-02-24 22:28:20 URL:https://www.wireshark.org/download/automated/data/manuf [2887602/2887602] -> "/tmp/tmp.PmjUnXNoN7" [1]<br>
chmod: cannot access ‘/usr/share/GeoIP/*.mmdb’: No such file or directory<br>

## Fixing GeoIP 

We are going to take a copy of the GeoLite2 files from Elastic and make a copy for Arkime<br>
```
sudo mkdir /var/lib/GeoIP
sudo find /var/lib/docker/overlay2/. -type f -name GeoLite2-Country.mmdb -exec cp '{}' /var/lib/GeoIP \;
sudo find /var/lib/docker/overlay2/. -type f -name GeoLite2-ASN.mmdb -exec cp '{}' /var/lib/GeoIP \;
```
# Update and add username/password of es01 

Use elastic as user and password you setup if it isn't student<br>
Add after updating elasticsearch= a pcap filter to ignore the IP of ELK server IP and 127.0.0.1 (localhost) from capturing packets<br>
````
sudo vi /opt/arkime/etc/config.ini
````
Update elasticsearch, add bpf filter and update 192.168.25.231 to your ELK server IP:<br>
elasticsearch=https://elastic:student@es01:9200<br>
bpf=not host 192.168.25.231 and not host 127.0.0.1 and not host ::1<br>

Find GeoIP and add the following to get GeoIP to work with Arkime<br>
- geoLite2Country=/var/lib/GeoIP/GeoLite2-Country.mmdb<br>
- geoLite2ASN=/var/lib/GeoIP/GeoLite2-ASN.mmdb<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/1978cc5a-3015-45f1-9332-0866719dca5d)

## Setup Arkime Tables

Use elastic as username and if your elastic password is different that **student**, update before running this script<br>
````
sudo /opt/arkime/db/db.pl --esuser elastic:student --insecure https://es01:9200 init
````
Update the following:<br>
````
sudo cp /var/lib/docker/volumes/dshield-elk_certs/_data/ca/ca.crt .
sudo mkdir /usr/share/ca-certificates/extra
sudo cp ca.crt /usr/share/ca-certificates/extra
sudo dpkg-reconfigure ca-certificates
````
## Edit and add --insecure to Configuration Scripts
````
sudo vi /etc/systemd/system/arkimecapture.service
````
ExecStart=/bin/sh -c '/opt/arkime/bin/capture --insecure -c /opt/arkime/etc/config.ini ${OPTIONS} >> /opt/arkime/logs/capture.log 2>&1'<br>
````
sudo vi /etc/systemd/system/arkimeviewer.service
````
ExecStart=/bin/sh -c '/opt/arkime/bin/node viewer.js --insecure -c /opt/arkime/etc/config.ini ${OPTIONS} >> /opt/arkime/logs/viewer.log 2>&1'<br>
````
sudo systemctl daemon-reload
````
*** **Note**: If you apply an update, you have to reapply _--insecure_ from this section because it get erased by the update.

$ sudo systemctl start arkimecapture.service<br>
$ sudo systemctl start arkimeviewer.service<br>
$ sudo systemctl status arkimecapture.service<br>
$ sudo systemctl status arkimeviewer.service<br>
$ sudo systemctl enable arkimecapture.service<br>
$ sudo systemctl enable arkimeviewer.service<br>

Confirm Arkime is Listening<br>
````
netstat -an | grep 8005
````
## Setup Arkime Login Username & Password

Default username is admin and password is training<br>
````
sudo /opt/arkime/bin/arkime_add_user.sh --insecure admin "Admin User" training --admin
````
### Login Arkime
Login into Arkime with username: admin and password: training<br>
**http:IP:8005**

### Troubleshooting

$ sudo bash /opt/arkime/bin/arkime_update_geo.sh<br>
$ sudo tail -f /opt/arkime/logs/capture.log<br>

### Checking for Missing packages against Arkime capture Binary
$ sudo ldd /opt/arkime/bin/capture<br>

### Reset Arkime Tables to Empty & Set Username/Password

$ sudo /opt/arkime/db/db.pl --esuser elastic:student --insecure https://es01:9200 init<br>
$ sudo /opt/arkime/bin/arkime_add_user.sh --insecure admin "Admin User" training --admin<br>

## Transfering pcap Files from DShield Sensor

The files from daemonlogger need to be transfered from the DShield sensor to ELK to import them into Arkime.<br>

If not already setup previously to transfer TTYlogs to ELK, configure SSH share keys<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/AddOn/Viewing_TTY_Logs_with_Lighttpd.md<br>

In ELK server, create SSH Shared Keys and don’t put a password:<br>
Copy id_rsa.pub over to each sensor(s). Likely the easiest way to copy the public key over might be to scp from DShield sensor. <br>
````
cd
ssh-keygen
ssh-copy-id -p 12222 guy@192.168.25.165
````

## Back on ELK server<br>

The **rename_arkime_pcap.sh** script should already be in the ~scripts directory.<br>
````
cd ~/scripts
vi rename_arkime_pcap.sh
````

Edit the script rename_arkime_pcap.sh<br>
- Update the variable SENSOR for you own DShield sensor(s).<br>
- Update default sudo password (i.e. training) used to sudo from your account to root<br>
See last command and change training to your own sudo password to import into Arkime<br>

### Add this cronjob to your Local Account

Transfer logs to ELK server every night at 1 AM<br>
0 1 * * * /home/guy/scripts/rename_arkime_pcap.sh > /dev/null 2>1&

## Replaying pcap Files into Arkime

Daemonlogger pcap files will be save in ~/pcap directory<br>

How to get previous unprocessed files from the DShield sensor? Repeat this scp get for each day by replacing the username and IP.<br>
**Important**: Each files must end with **_.pcap_** for the Arkime script to load them into ELK<br>

Before executing the _~/scripts/rename_arkime_pcap.sh_, you need to edit the script and comment (add #) to this line:<br>
Like this: **#/usr/bin/rm -f $HOME/pcap/***<br>

$ cd $/pcap
$ scp -P 12222 guy@192.168.25.28:/srv/NSM/dailylogs/2024-02-17/daemonlogger* .<br>
Execute the $ ~/scripts/rename_arkime_pcap.sh<br>
It will rename the files and load them into Arkime<br>

After running the script, edit the script and remove the comment (#) from the /usr/bin/rm -f $HOME/pcap/<br>

The reason I'm removing these files before the next scp is to ensure we don't load the same files every day.

To manually load .pcap file(s) into Arkime, place the file in ~/pcap and run this command:<br>
$ sudo /opt/arkime/bin/capture --insecure --config /opt/arkime/etc/config.ini --host es01 --pcapdir ~/pcap --skip --recursive sensor1

# Arkime Dashboard
Access Arkime http:IP:8005<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/8e8813fc-ed69-4ed6-9c1a-7e2f692b9777)

# Arkime & CyberChef

CyberChef is available as part of Arkime and can be accessed by expending the + beside the protocol
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/d85bc926-8271-4d80-9df5-30f4540dd9d0)


 [1] https://arkime.com<br>
 [2] https://github.com/arkime/arkime/releases/
