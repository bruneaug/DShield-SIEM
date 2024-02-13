# Packet Capture with Daemonlogger
Daemonlogger is a packet capture software by Cisco Talos[1] which capture the packets and save them to disk. This used to be the primary packet capture software with Sguil[2].

$ sudo apt install daemonlogger

Copy to the sensor packet_capture.tgz tarball to your home user account and extract it as follow:<br>
$  curl -LJO https://github.com/bruneaug/DShield-SIEM/raw/main/AddOn/packet_capture.tgz<br>
$ sudo tar zxvf packet_capture.tgz -C /<br>

## Edit the log_packets.sh Script
The log_packets.sh script need to be edit and update the DShield sensor interface before it can capture.<br>
$ ifconfig (get the sensor interface, eth0, ens18, etc)<br>

Search for INTERFACE and replace ens18 with the current interface<br>
$ sudo vi /etc/init.d/log_packets.sh<br>

### Lets start packet capture
$ sudo /etc/init.d/log_packets.sh start<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/b4479f06-2848-4334-93eb-b9d8bcb0824f)

[1] https://www.talosintelligence.com/daemon<br>
[2] https://bammv.github.io/sguil/index.html
