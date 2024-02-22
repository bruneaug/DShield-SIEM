# Setup Arkime with DShield-SIEM

### Latest release version 5.01-1 -> 20 Feb 2024<br>

This is the steps necessary to install Arkime [1] to parse and index the daemonlogger logs captured by the DShield sensor.

$ sudo su -<br>
echo "192.168.25.231 es01" >> /etc/hosts<br>
exit

# Download & Install Arkime

$ mkdir arkime<br>
$ cd arkime<br>
$ curl -LJO https://github.com/arkime/arkime/releases/download/v5.0.1/arkime_5.0.1-1.ubuntu2004_amd64.deb<br>
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
chmod: cannot access ‘/usr/share/GeoIP/*.mmdb’: No such file or directory<br>

## Fixing GeoIP 

We are going to take a copy of the GeoLite2 files from Elastic and make a copy for Arkime<br>

$ sudo mkdir /var/lib/GeoIP<br>
sudo find /var/lib/docker/. -type f -name GeoLite2-Country.mmdb | xargs -r -I file sudo cp GeoLite2-Country.mmdb /var/lib/GeoIP<br>
sudo cp /var/lib/docker/overlay2/e065c7e8bb347d150cbb7aa18aae61989ad52451546e1ba2190100cef8c7fd85/diff/usr/share/logstash/vendor/bundle/jruby/3.1.0/gems/logstash-filter-geoip-7.2.13-java/vendor/GeoLite2-ASN.mmdb /var/lib/GeoIP<br>

# Update and add username/password of es01 

Use elastic as user and password you setup if it isn't student

$ sudo vi /opt/arkime/etc/config.ini

Update to: elasticsearch=https://elastic:student@es01:9200

Add the following to get GeoIP to work with Arkime<br>
- geoLite2Country=/var/lib/GeoIP/GeoLite2-Country.mmdb<br>
- geoLite2ASN=/var/lib/GeoIP/GeoLite2-ASN.mmdb<br>


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

*** **Note**: If you apply an update, you have to reapply _--insecure_ from this section because it get erased by the update.

$ sudo systemctl start arkimecapture.service<br>
$ sudo systemctl start arkimeviewer.service<br>
$ sudo systemctl status arkimecapture.service<br>
$ sudo systemctl status arkimeviewer.service<br>
$ sudo systemctl enable arkimecapture.service<br>
$ sudo systemctl enable arkimeviewer.service<br>

Confirm Arkime is Listening
$ netstat -an | grep 8005

## Setup Arkime Login Username & Password

Default username is admin and password is training<br>

$ sudo /opt/arkime/bin/arkime_add_user.sh --insecure admin "Admin User" training --admin<br>

### Login Arkime

http:IP:8005

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

## Back on ELK server<br>

The **rename_arkime_pcap.sh** script should already be in the ~scripts directory.<br>

Edit the script rename_arkime_pcap.sh
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
$  scp -P 12222 guy@$192.168.25.105:/srv/NSM/dailylogs/2024-02-17/daemonlogger* .
Execute the $ ~/scripts/rename_arkime_pcap.sh<br>
It will rename the files and load them into Arkime

To manually load .pcap file(s) into Arkime, place the file in ~/pcap and run this command:<br>
$ sudo /opt/arkime/bin/capture --insecure --config /opt/arkime/etc/config.ini --host es01 --pcapdir ~/pcap --skip --recursive sensor1

# Arkime Dashboard
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/8e8813fc-ed69-4ed6-9c1a-7e2f692b9777)


 [1] https://arkime.com<br>
 [2] https://github.com/arkime/arkime/releases/
