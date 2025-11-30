# Installing Suricata on DShield Sensor

This is currently just a placeholder<br>
Update the sensor before the installation of Suricata<br>
```
sudo apt update && sudo apt upgrade -y
```
Installing Suricata<br>
```
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt update
sudo apt install suricata -y
sudo suricata --version
sudo vi /etc/suricata/suricata.yaml
```
Update the configuration file<br>
<pre>
af-packet:
  - interface: eth0 enp2s0 ens3
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
</pre>
Updating the signatures and starting Suricata<br>
```
sudo suricata-update
sudo systemctl restart suricata
sudo suricata -c /etc/suricata/suricata.yaml -i eth0
```
View the logs
```
cat /var/log/suricata
```

sgh-mpm-caching: yes
sgh-mpm-caching-path: /var/lib/suricata/cache/sgh

