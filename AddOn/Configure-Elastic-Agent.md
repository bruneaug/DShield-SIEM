# Add elastic-agent to DShield Sensor

TLS Certificate is Need to Connect to ELK<br>
Login the ELK server home user account and copy the ca.crt to ~.<br>
$ sudo cp /var/lib/docker/volumes/dshield-elk_certs/_data/ca/ca.crt  .<br>
$ sudo chown guy:guy ca.crt (change it to your username:username)<br>

## Login DShield Sensor<br>
From the DShield sensor, copy the certificate to this directory<br>
$ scp guy@192.168.25.231:/home/guy/ca.crt .<br>
$ mv ca.crt ca.pem<br>
$ sudo cp ca.pem /etc/ssl/certs/<br>
$ sudo mv ca.pem /usr/local/share/ca-certificates<br>
$ sudo update-ca-certificates -v<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/84c067b2-0358-425f-b8bb-bc3eb911c151)

## Add ELK IP to DShield sensor:

$ sudo su -<br>
echo "192.168.25.231 fleet-server" >> /etc/hosts<br>
echo "192.168.25.231 es01" >> /etc/hosts<br>
sudo apt-get install elastic-agent<br>
Note: elastic-agent must be the same version as the ELK server. If the agent is a newer version, you need to use a command like this or update the .env file to reflect the current version of ELK:<br>
_curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.11.0-amd64.deb_<br>
_sudo dpkg -i elastic-agent-8.11.0-amd64.deb_<br>

## Enable the elastic-agent

$ sudo systemctl enable elastic-agent<br>
$ sudo systemctl stop elastic-agent<br>
$ sudo systemctl start elastic-agent<br>
Reference: https://hub.docker.com/_/elasticsearch <br>

To add elastic-agent to DShield sensor do:<br>
Management -> Fleet -> Agent policies -> Create agent policy:<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/e6d22e40-c01a-4a8b-a8c0-6d7cd5e2e3e6)
 
## Select: Create agent policy

After the policy is created, select the policy (DShield Sensor), Actions -> Add agent <br>
Pick RPM and copy line 3 and format it like this:<br>
sudo elastic-agent enroll \
  --url=https://fleet-server:8220 \
  --certificate-authorities=/etc/ssl/certs/ca.pem \
  --enrollment-token=RVFIbEo0MEJKRzNBblNzWHJCb3U6dy1WemJnRnVRVzJJZTdDX29PR2Ftdw== \
  --insecure
The DShield sensor should show this confirmation after it is added:<br>
 
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/d03fa3d9-9bf7-4c60-87b5-fdc570f41aec)
 
The server will show the following:

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/107bd46d-d33b-40fc-b6a0-841c4441efe3)

This confirm the DShield sensor is now added to ELK<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/1e884e05-9bc5-4058-a908-3a428fbe45d9)
 
Now we can configure the Agent policies by adding integration like we did for the Fleet Server Policy, select Agent policies -> DShield Sensor -> Add integration:<br>
•	NetFlow Records (add-on with softflowd if you want NetFlow data from the sensor)<br>
•	Network Traffic (packetbeat equivalent)<br>
•	System is the default agent<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/7011a635-deff-484e-b8ee-88b30524bc14)
 
# Configure softflowd Application<br>
This application will capture NetFlow traffic targeting your DShield sensor and report it to ELK under the NetFlow dashboard<br>

$ sudo vi /etc/softflowd/default.conf<br>
Set the interface (usually eth0 for PI)<br>
Set: options= "-v 9 -P udp -n 127.0.0.1:2055" (Must be double quotes)<br>
Save the changes and restart the service<br>
$ sudo systemctl restart softflowd<br>

$ netstat -an | grep 2055  (Confirm softflowd is running)<br>
The flows can be viewed with this dashboard:<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/4372dc5d-ad41-45b1-a81c-63d191851c3e)

 
