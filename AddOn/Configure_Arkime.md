# Setup Arkime with DShield-SIEM

This is the steps necessary to install Arkime [1] to parse and index the daemonlogger logs captured by the DShield sensor.

$ sudo su -<br>
echo "192.168.25.231 es01" >> /etc/hosts<br>
exit

# Download & Install Arkime

$ mkdir arkime<br>
$ cd arkime<br>
$ curl -LJO https://github.com/arkime/arkime/releases/download/v5.0.0/arkime_5.0.0-1.ubuntu2004_amd64.deb<br>
$ wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.21_amd64.deb<br>
$ sudo apt install ./libssl1.1_1.1.1f-1ubuntu2.21_amd64.deb<br>
$ sudo apt-get install -yq curl libmagic-dev wget logrotate libffi-dev libffi7<br>
$ sudo apt-get install ./arkime_5.0.0-1.ubuntu2004_amd64.deb --fix-broken<br>


# Configure Arkime
The bolded data is the sugest configuration. The default password (student) is the password for Arkime to login ELK.<br>
Use what you configure in .env if it is different than student.<br>

$ sudo /opt/arkime/bin/Configure<br>

Found interfaces: br-e4754292a395;docker0;ens160;lo;veth163b883;veth2e92487;veth3e371fe;vethee3c267<br>
Semicolon ';' seperated list of interfaces to monitor [eth1] **lo**<br>
Install Elasticsearch server locally for demo, must have at least 3G of memory, NOT recommended for production use (yes or no) [**no**]<br>
Elasticsearch server URL [http://localhost:9200] https://es01:9200<br>
Password to encrypt S2S and other things, don't use spaces [no-default] **student**<br>
Arkime - Creating configuration files<br>

Installing sample /opt/arkime/etc/config.ini<br>

Arkime - Installing /etc/security/limits.d/99-arkime.conf to make core and memlock unlimited<br>
Download GEO files? You'll need a MaxMind account https://arkime.com/faq#maxmind (yes or no) [**yes**]<br>
Arkime - Downloading GEO files<br>
2024-02-16 22:30:49 URL:https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv [23323/23323] -> "/tmp/tmp.6m3dNzyHi5" [1]<br>
2024-02-16 22:30:50 URL:https://www.wireshark.org/download/automated/data/manuf [2721990/2721990] -> "/tmp/tmp.PmjUnXNoN7" [1]<br>

# Update and add username/password of es01 

Use elastic as user and password you setup if it isn't student

$ sudo vi /opt/arkime/etc/config.ini

Update to: elasticsearch=https://elastic:student@es01:9200

## Setup Arkime Tables

Use elastic as username and if your elastic password is different that **student**, update before running this script<br>

$ sudo /opt/arkime/db/db.pl --esuser elastic:student --insecure https://es01:9200 init<br>

$ sudo cp /var/lib/docker/volumes/dshield-elk_certs/_data/ca/ca.crt .<br>
$ sudo mkdir /usr/share/ca-certificates/extra<br>
$ sudo cp ca.crt /usr/share/ca-certificates/extra<br>
$ sudo dpkg-reconfigure ca-certificates<br>

## Edit and add --insecure to Configuration Scripts

$ sudo vi /etc/systemd/system/arkimecapture.service<br>
ExecStart=/bin/sh -c '/opt/arkime/bin/capture --insecure -c /opt/arkime/etc/config.ini ${OPTIONS} >> /opt/arkime/logs/capture.log 2>&1'<br>

$ sudo vi /etc/systemd/system/arkimeviewer.service<br>
ExecStart=/bin/sh -c '/opt/arkime/bin/node viewer.js --insecure -c /opt/arkime/etc/config.ini ${OPTIONS} >> /opt/arkime/logs/viewer.log 2>&1'<br>

$ sudo systemctl daemon-reload

$ sudo systemctl start arkimecapture.service<br>
$ sudo systemctl start arkimeviewer.service<br>
$ sudo systemctl status arkimecapture.service<br>
$ sudo systemctl status arkimeviewer.service<br>
$ sudo systemctl enable arkimecapture.service<br>
$ sudo systemctl enable arkimeviewer.service<br>

Confirm Arkime is Listening
$ netstat -an | grep 8005

## Setup Login Username & Password

Default username is admin and password is training<br>

$ sudo /opt/arkime/bin/arkime_add_user.sh --insecure admin "Admin User" training --admin<br>

### Login Arkime

http:IP:8005

## Replaying pcap Files into Arkime

Daemonlogger pcap files will be save in ~/pcap directory<br>

$ sudo /opt/arkime/bin/capture --insecure --config /opt/arkime/etc/config.ini --host es01 --pcapdir /home/student/pcap/ --skip --recursive sensor1

### Troubleshooting

$ sudo bash /opt/arkime/bin/arkime_update_geo.sh<br>
$ sudo tail -f /opt/arkime/logs/capture.log<br>

### Checking for Missing packages against Arkime capture Binary
$ sudo ldd /opt/arkime/bin/capture<br>

Reset Arkime Tables to Empty & Set Username/Password

sudo /opt/arkime/db/db.pl --esuser elastic:student --insecure https://es01:9200 init
sudo /opt/arkime/bin/arkime_add_user.sh --insecure admin "Admin User" training --admin

## Transfering pcap Files from DShield Sensor

The files from daemonlogger need to be transfered from the DShield sensor to ELK to import them into Arkime.<br>

If not already setup previously to transfer TTYlogs to ELK, configure SSH share keys<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/AddOn/Viewing_TTY_Logs_with_Lighttpd.md<br>

In ELK server, create SSH Shared Keys and don’t put a password:<br>

$ ssh-keygen<br>
Copy id_rsa.pub over to each sensor(s). Likely the easiest way to copy the public key over might be to scp from DShield sensor. <br>
$ scp guy@192.168.25.231:/home/guy/.ssh/id_rsa.pub .<br>
$ cat id_rsa.pub >> .ssh/authorized_keys<br>
$ rm id_rsa.pub<br>

Back on ELK server<br>
Edit the script rename_arkime_pcap.sh and update the variable SENSOR for you own DShield sensor(s).<br>
Using default password to sudo commands: training
See last command and change training to your own sudo password to import into Arkime



 [1] https://arkime.com/
