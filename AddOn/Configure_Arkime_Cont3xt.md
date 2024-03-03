# Arkime Cont3xt Threat Intelligence

"**Cont3xt centralizes and simplifies a structured approach to gathering contextual intelligence in support of technical investigations.**"[1]<br>
Login the ELK server to enable Cont3xt to gather threat intelligence from multiple locations.<br>

### Setup Cont3xt
$ sudo /opt/arkime/bin/Configure --cont3xt

### Configure Cont3xt
Edit /opt/arkime/etc/cont3xt.ini and update elasticsearch setting<br>
$ sudo vi /opt/arkime/etc/cont3xt.ini

**Important**: passwordSecret must match the same passwordSecret that was added to /opt/arkime/etc/config.ini<br>
Edit config.ini and copy the _paswordSecret_<br>

$ sudo vi /opt/arkime/etc/config.ini

Now edit the cont3xt.ini and set the 2 required fields<br>
$ sudo vi /opt/arkime/etc/cont3xt.ini

elasticsearch=https://elastic:student@es01:9200
passwordSecret=student

Next we need to add --insecure to the service to start correctly<br>
$ sudo vi /etc/systemd/system/arkimecont3xt.service

ExecStart=/bin/sh -c '/opt/arkime/bin/node cont3xt.js --insecure -c /opt/arkime/etc/cont3xt.ini ${OPTIONS} >> /opt/arkime/logs/cont3xt.log 2>&1'

$ sudo systemctl daemon-reload<br>
$ sudo systemctl start arkimecont3xt<br>
$ sudo systemctl status arkimecont3xt<br>
$ sudo systemctl enable arkimecont3xt<br>
Check to see if the services is started listening on TCP 3218
$ netstat -an | grep 3218<br>

Login in the service using the same username/password set for Arkime<br>
http://IP:3218

## Kibana Interface Direct Cont3xt Access
If you want to take advantage of the right click function, you may need to download and install the latest update for dshield_sensor_8.11.1.ndjson<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/scripts/dshield_sensor_8.11.1.ndjson<br>

If downloading from Windows, download the file this way to prevent modification<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/287e4f01-de8b-4a5d-9cb2-7cf515c0a9a1)



You will also need in ELK to go to Management -> Stack Management -> Kibana -> Data Views<br>
Edit Cont3xtHash and Cont3xtIP and change the IP of the URL (192.168.25.231) to your own ELK IP to query Cont3xt directly from the interface<br>

# Login the Interface and Configure Threat Intelligence Sites
Goto Settings -> Integrations
If you have your own keys for Virustotal, AlienVault OTX, Shodan, etc, you can add them here which will run the query to each of these sites for you.

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/01c24a0e-6a48-4244-98d8-fafa57ee9f8e)

# Analysis Example
This is an example of an IP and file hash analysis. Each of the top icone that have a number, select the number to see the data<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/72a8a4a0-4d06-4ad6-a327-b0254dbb92c7)


[1] https://arkime.com/cont3xt
