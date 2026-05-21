# Installing Suricata on DShield Sensor

This is currently just a placeholder<br>
Update the sensor before the installation of Suricata<br>
```
sudo apt update && sudo apt upgrade -y
```
## Installing Suricata<br>
```
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt update
sudo apt install suricata -y
sudo mkdir /var/run/suricata
chown suricata:suricata /var/run/suricata
sudo suricata --version
```
### Editing the Configuration File
```
sudo vi /etc/suricata/suricata.yaml
```
### Update the configuration file<br>
Edit the configuration file and select the correct interface to get Suricata<br>
detecting activity based on your IDS signature selection. <br>
<pre>
af-packet:
  - interface: eth0 enp2s0 ens3
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
</pre>
### Updating Signatures
Before activating Suricata, update the signatures to the latest available.<br>
```
sudo suricata-update
```
### Starting Suricata

```
sudo systemctl enable suricata
sudo systemctl restart suricata
sudo systemctl status suricata
```
### Rule Classification
```
sudo vi /var/lib/suricata/rules/classification.config
```
### Rule Location
```
/usr/share/suricata/rules/
```
### View the logs
This is the default log location for Suricata. If using DShield SIEM, those would also be sent to the SIEM.<br>
```
cat /var/log/suricata
```

sgh-mpm-caching: yes
sgh-mpm-caching-path: /var/lib/suricata/cache/sgh

