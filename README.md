# DShield Sensor Log Collection 
## Introduction
This is fork and a significant update from the initial publication on the ISC Storm Center website by Scott Jensen as a BACS paper and the scripts published in Github.
https://github.com/fkadriver/Dshield-ELK
https://isc.sans.edu/diary/DShield+Sensor+Monitoring+with+a+Docker+ELK+Stack+Guest+Diary/30118

# Setup Filebeat on DShield Sensor
After completing the installation of the SQLite database, add the following ARM64 Filebeat packages to the Pi to send the logs the Elasticsearch.

Installing ARM64 Filebeat package using [3] the following commands:

$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
$ sudo apt-get install apt-transport-https
$ echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
$ echo "deb https://artifacts.elastic.co/packages/oss-8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
$ sudo apt-get update && sudo apt-get install filebeat

Download the updated filebeat.yml file that will forward the logs the Elasticsearch:

$ sudo curl https://handlers.sans.edu/gbruneau/elk//DShield/filebeat.yml -o /etc/filebeat/filebeat.yml

Edit the filebeat.yml file and change the IP address to the logstash parser (192.168.25.23):

$ sudo vi /etc/filebeat/filebeat.yml

### Start Filebeat

$ sudo systemctl enable filebeat
$ sudo systemctl start filebeat
$ sudo systemctl status filebeat

# Setup webhoneypot.sh Parser

This is a hourly script that extract the logs hourly and Filebeat send them to Logstash
The script is kept in: ~/scripts but can be put where you want. The cronjob runs every hour

# Dump the cowrie web logs every hours
1 * * * * /home/guy/scripts/webhoneypot.sh  > /dev/null 2>1&

# Ubuntu Setup

- Minimum 8 GB RAM
- 4-8 Cores
- Minimum 40 GB Separate partition for /var/lib/docker

1. Have setup filebeat per Install & Configure Filebeat on Raspberry Pi ARM64 to Parse DShield Sensor Logs [2] up to the Setup Logstash Collection & Parsing
2. Install docker
 $ sudo apt-get install ca-certificates curl gnupg network-manager
 $ sudo install -m 0755 -d /etc/apt/keyrings
 $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 $ sudo chmod a+r /etc/apt/keyrings/docker.gpg
 $ echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 $ sudo apt update && sudo apt upgrade
 $ sudo reboot (if update were applied)
 $ sudo apt-get install -y jq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin pip
 $ sudo systemctl enable docker

# Configure and install DShield ELK

$ tar zxvf Dshield-ELK
$ cd ~/Dshield-ELK
Note: Before installation, you can edit the .env file to make any derided changes.
    - Current default password for elastic is student
Memory Limits in .env are the most memory that docker will allocate for each of the ELK containers. Default to 2147483648 (2GB) but can be expanded if you have the resources
$ sudo docker compose up -d (For setup or any changes)

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/dcc963af-357f-4b74-b7e5-7acf84438750)

Installation Completed
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/df44cf7d-b105-4188-abe7-983311e313d3)

# Access Kibana Interface

Web Access: http://serverIP:5601

# Configure elastic-agent
The elastic-agent will be used to ingest threat intelligence. It can also be used to do other things that won’t be covered here.
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/6ff32abf-7bf7-4185-8e6d-ae6373d88bea)

- Login Kibana with username: elastic and default password: student
- From the dropdown menu, select Management → Fleet →Settings → Edit Outputs (Actions)
- Login server via SSH
- Copy ca.crt certificate to /tmp
$ sudo docker cp dshield-elk-es01-1:/usr/share/elasticsearch/config/certs/ca/ca.crt /tmp/.

- Get a copy of Elasticsearch CA trusted fingerprint
$ sudo openssl x509 -fingerprint -sha256 -noout -in /tmp/ca.crt | awk -F"=" {' print $2 '} | sed s/://g

- The output will look like this:
673FB617E15CCCE73F9B647EF99449642A19CFC1D75BF5772047DA99DB950844

Get Content of Elasticsearch CA Certificate to Apply to Advanced YAML configuration
$ sudo cat /tmp/ca.crt 

Format must be exactly like this. Copy the output of the certificate in Notepad or Notepad++ and format exactly like this. It needs 2 spaces before certificate_authorities: and the dash (-) and it needs 4 spaces from the pipe (|) all the way down to the end of -----END CERTIFICATE-----

- Change the Hosts to: https://es01:9200

Save and apply settings after making the changes and adding the certificate information.
Followed by Save and deploy
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/82d3b29f-5398-4f23-afea-63bf6727e087)
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/bc97d11c-b9de-4c26-b24e-17ebed278cd2)

The raw output for the Certificate should look like this with the same spaces as per this picture. Two spaces from the left for the certificate certificate_authorities: and four spaces from the left from the pipe (|) to the end of certificate [9]:

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/002cc7c6-ecba-4b1e-b5de-2bf97915854e)

Under Settings, configure the Fleet server hosts by either edit or Add Fleet Server configured as follows:

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/8c6abd5d-a7ba-4183-842a-c98410bd21f0)

Next phase is to Select Agent Policy → Add Agent → Enroll in Fleet → Add Fleet Server

- Provide a Name: es01
- Provide URL: https://fleet-server:8220
- Last: Generate Fleet Server policy
- Select: RPM
- Copy starting at: elastic-agent enroll \ to the end of …port=8220
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/2499e7d8-86fd-4b7f-a3f1-d401dc43ddde)

We are going to need this information to setup our fleet server. Login via SSH to the fleet-server to setup our agent:
$ sudo docker start dshield-elk-fleet-server-1
$ sudo docker exec -ti dshield-elk-fleet-server-1 bash
This is an example of what need to be copied to the fleet server. Ensure the fleet server es is: https://es01:9200
Add the bold section after port=8220 because are certificates are self-generated. This will ensure the agent takes the update.
The token and fingerprint will be different then my example:

elastic-agent enroll \
  --fleet-server-es=https://es01:9200 \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE3MDU0NDg3MDMwNTI6NkNxcWlCeTRRVmlhYW0yeldhN3pGZw \
  --fleet-server-policy=fleet-server-policy \
  --fleet-server-es-ca-trusted-fingerprint=76DA77DAE186F8CFBA9E87D450D5419B68E2555A9BD57795611C0545ED0BF03F \
  --fleet-server-port=8220 \
  --certificate-authorities=/certs/ca/ca.crt \
  --fleet-server-es-ca=/certs/es01/es01.crt
  --fleet-server-cert=/certs/fleet-server/fleet-server.crt \
  --fleet-server-cert-key=/certs/fleet-server/fleet-server.key \
  --fleet-server-es-insecure

This will replace your current settings. Do you want to continue? [Y/n]: Y
{"log.level":"info","@timestamp":"2024-01-17T00:00:40.404Z","log.origin":{"file.name":"cmd/enroll_cmd.go","file.line":411},"message":"Generating self-signed certificate for Fleet Server","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2024-01-17T00:00:42.774Z","log.origin":{"file.name":"cmd/enroll_cmd.go","file.line":788},"message":"Fleet Server - Running on policy with Fleet Server integration: fleet-server-policy; missing config fleet.agent.id (expected during bootstrap process)","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2024-01-17T00:00:43.073Z","log.origin":{"file.name":"cmd/enroll_cmd.go","file.line":479},"message":"Starting enrollment to URL: https://a4a1ada63084:8220/","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2024-01-17T00:00:44.152Z","log.origin":{"file.name":"cmd/enroll_cmd.go","file.line":277},"message":"Successfully triggered restart on running Elastic Agent.","ecs.version":"1.6.0"}
Successfully enrolled the Elastic Agent.
From your current location, verify it installed correctly 
$ ./elastic-agent status

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/7739c64e-5c10-4a0c-85e8-7be20749a05f)
In Elastic Management → Fleet, refresh Agents and this is what shows up:
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/144f24f6-2f53-45b2-acaa-41f796efe6a3)

The server is now ready to install Threat Intel Agents to be used in Security (SIEM portion) against the honeypot logs. The next step is to select Agent policies → Fleet Server Policy → Add integration:
Select and Add AlienVault OTX (need an API key)
Select AbuseCH (no API key needed)
Select Threat Intelligence Utilities

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/64f795cf-e761-42ca-b94a-a79e87b16ee6)

In Elastic Management → Installed Integration
Select each of the installed integration and select Settings and enable this:
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/2b3c2e40-c6ce-4963-9002-ad76b72ebc77)

## Configuring Security → Rules

- Select Rules → Detection rules (SIEM) → Add Elastic rules
- Under Search Tags: Rule Type: Indicator Match (4 rules)
- Install and enable those 4 rules
- You can look through the rules and enable those other rules that you want to try against your honeypot data.
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/4fec2d86-208a-465d-8853-9456acc7913f)

## Configure Management → Stack Management → Advanced Settings
Find Elasticsearch Indices and add at the end of the list:
- ,cowrie*
- Save changes for these logs to be analyzed by the SIEM part of ELK.



# References
[1] https://isc.sans.edu/tools/honeypot/

[2] https://www.elastic.co/downloads/beats/filebeat

[3] https://www.elastic.co/guide/en/beats/filebeat/8.8/setup-repositories.html#_apt

[4] https://isc.sans.edu/diary/DShield+Honeypot+Activity+for+May+2023/29932

[5] https://isc.sans.edu/diary/DShield+Sensor+JSON+Log+to+Elasticsearch/29458

[6] https://isc.sans.edu/diary/DShield+Sensor+JSON+Log+Analysis/29412

[7] https://github.com/jslagrew/cowrieprocessor/blob/main/submit_vtfiles.py
[8] https://handlers.sans.edu/gbruneau/elastic.htm
[9] https://www.elastic.co/guide/en/fleet/current/secure-connections.html
