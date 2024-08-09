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
logs for longer, you can add a separate partition.<br>
As an example, see: https://github.com/bruneaug/DShield-SIEM/blob/main/AddOn/Build_a_Docker_Partition.md<br>
MAX_DISK_USE=75

Interface to 'listen' to.<br>
INTERFACE="**_ens18_**"

Edit the default filter that exclude Logstash (5044), Elastic (8220, 9200), remote SSH management (12222) and DNS (UDP/53)<br>
Change the host IP address (192.168.25.105) with your sensor IP. You can modify the filter to meet your needs.<br>

$ sudo vi /etc/init.d/log_packets.sh<br>
Search for INTERFACE and replace **ens18** with the current interface<br>

Update the filter to match your sensor IP<br>
_**FILTER='src host 192.168.25.105 or dst host 192.168.25.105 and not \(port 9200 or port 5044 or port 8220 or port 12222 or udp port 53\)'**_<br>
-- Then save the changes

### Lets start packet capture
$ sudo /etc/init.d/log_packets.sh start<br>
The pcap are saved in this location: /srv/NSM/dailylogs/<br>
By date like this: 2024-02-13<br>
It is currently setup for a file per day. Depending of the packet capture, the file could be significantly large.<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/b4479f06-2848-4334-93eb-b9d8bcb0824f)

The packet capture will start when the sensor is started, it is setup to start on boot:<br>
/etc/rc3.d/S01log_packets<br>

## Nightly Root Cronjob

This nightly cronjob is installed by default to the root account. It is used to restart packet capture every night at midnight.<br>

The log_packet.sh must be enabled to copy packets with daemonlogger<br>
0 0 * * * /etc/rc3.d/S01log_packets restart > /dev/null 2>1&<br>

This complete packet capture setup with daemonlogger.

[1] https://www.talosintelligence.com/daemon<br>
[2] https://bammv.github.io/sguil/index.html
