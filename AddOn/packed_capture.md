# Packet Capture with Daemonlogger
Daemonlogger is a packet capture software by Cisco Talos[1] which capture the packets and save them to disk. This used to be the primary packet capture software with Sguil[2].

$ sudo apt install daemonlogger

Copy to the sensor packet_capture.tgz tarball to your home user account and extract it as follow:<br>
$  curl -LJO https://github.com/bruneaug/DShield-SIEM/raw/main/AddOn/packet_capture.tgz<br>
$ sudo tar zxvf packet_capture.tgz -C /<br>

## Edit the log_packets.sh Script
The log_packets.sh script need to be edit and update the DShield sensor interface before it can capture.<br>
$ ifconfig (get the sensor interface, eth0, ens18, etc)<br>

Percentage of disk to try and maintain - I set mine to 75% for /srv but that can be adjusted to meet your need<br>
The directory (or partition) also contains to downloads, cowrie logs and webhoneypot logs. If you want to keep your<br>
logs for longer, you can add a separate partition. 
MAX_DISK_USE=75

Interface to 'listen' to.
INTERFACE="_ens18_"

Edit the default filter that exclude Logstash (5044), Elastic (8220, 9200) and DNS (UDP/53)<br>
Change the host IP address (192.168.25.105) with your sensor IP. You can modify the filter to meet your needs.<br>

_FILTER='src host 192.168.25.105 or dst host 192.168.25.105 and not \(port 9200 or port 5044 or port 8220 or udp port 53\)'_<br>
-- Then save the changes

Search for INTERFACE and replace ens18 with the current interface<br>
$ sudo vi /etc/init.d/log_packets.sh<br>

### Lets start packet capture
$ sudo /etc/init.d/log_packets.sh start<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/b4479f06-2848-4334-93eb-b9d8bcb0824f)

[1] https://www.talosintelligence.com/daemon<br>
[2] https://bammv.github.io/sguil/index.html
