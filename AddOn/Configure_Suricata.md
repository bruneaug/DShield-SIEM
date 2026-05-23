# Installing Suricata on DShield Sensor

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
- Adjust the network collection to your network.
- I suggest you can turn off logging to "fast".
detecting activity based on your IDS signature selection. <br>
<pre>
af-packet:
  - interface: eth0 enp2s0 ens3
    bpf-filter: "not host 192.168.25.1"
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes

  vars:
  # more specific is better for alert accuracy and performance
  address-groups:
    HOME_NET: "[192.168.25.28/32]"

  - fast:
      enabled: no
      filename: fast.log
      append: yes
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
# Tuning the Sensor Rules
Disable Signatures

sudo vi /etc/suricata/ disable.conf
<pre>
# Disable a specific signature by its SID
# SURICATA Ethertype unknown
2200121
# Or disable an entire category/group
group:emerging-icmp.rules 
</pre>

### Update the Ruleset before Restarting
```
sudo suricata-update
sudo systemctl restart suricata
```
### Confirm the SID has been Removed from the Ruleset
```
sudo grep "sid:2200121 /var/lib/suricata/rules/suricata.rules
```
### Result that Confirms Rule has been Removed
This picture shows the rule has been commented out (#)
<img width="1053" height="48" alt="image" src="https://github.com/user-attachments/assets/93896b84-ac80-49d1-81e0-9ae7ef90f7e3" />

sgh-mpm-caching: yes
sgh-mpm-caching-path: /var/lib/suricata/cache/sgh

