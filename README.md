fv# DShield Sensor Log Collection with Elasticsearch
## Introduction
This is fork and a significant update from the initial publication on the ISC Storm Center website by Scott Jensen as a BACS paper and the scripts published in Github.<br>
https://github.com/fkadriver/Dshield-ELK<br>
https://isc.sans.edu/diary/DShield+Sensor+Monitoring+with+a+Docker+ELK+Stack+Guest+Diary/30118<br>

# What it is Used For
This docker is custom built to be used with the DShield Honeypot [1] to collect and parse the logs and collect its data in a visual and easy to search for research purposes. The default installion example by DShield is to install it in a Rasperry using PI Raspbian OS or a system running Ubuntu 20.04 LTS.

# Ubuntu Setup
- Ubuntu 20.04 LTS Live Server 64-Bit or Raspbian OS 64-Bit
- Minimum 8+ GB RAM
  - If the amount of RAM assigned to each containers (see below) is more than 2GB, consider increasing the server RAM capacity.
- 4-8 Cores
- Minimum 40 GB partition assigned to /var/lib/docker
## Elastic Packages Installed
- Kibana
- Elasticsearch
- Logstash
- Elastic-Agent

## Install docker
 $ sudo apt-get install ca-certificates curl gnupg network-manager<br>
 $ sudo install -m 0755 -d /etc/apt/keyrings<br>
 $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg<br>
 $ sudo chmod a+r /etc/apt/keyrings/docker.gpg<br>
 $ echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \\<br>
   "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null<br>
 $ sudo apt update && sudo apt upgrade<br>
 $ sudo reboot (if update were applied)<br>
 $ sudo apt-get install -y jq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin pip<br>
 $ sudo systemctl enable docker<br>

# Configure and install DShield ELK

$ git clone https://github.com/bruneaug/DShield-SIEM.git<br>
$ chmod +x scripts/*.sh<br>
$ chmod 754 DShield-SIEM/scripts/cowrie-setup.sh<br>
$ cd ~/DShield-SIEM<br>

The script ~/scripts/startelk.sh should be edited if you modified the elastic password to reflect your user account password. Default is currently _student_.<br>
**Note**: Before installation, you can edit the .env file to make any derided changes.<br>
    - Current _default password_ for elastic is **student**<br>
Memory Limits in **.env** are the most memory that docker will allocate for each of the ELK containers.<br>
Default to **2147483648** (2GB) but can be expanded if you have the resources<br>

$ sudo docker compose up -d (For setup or any changes)<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/dcc963af-357f-4b74-b7e5-7acf84438750)

Installation Completed

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/df44cf7d-b105-4188-abe7-983311e313d3)

# Access Kibana Interface

Web Access: http://serverIP:5601

# Configuring elastic-agent
The elastic-agent will be used to ingest threat intelligence. It can also be used to do other things that won’t be covered here.

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/6ff32abf-7bf7-4185-8e6d-ae6373d88bea)

- Login Kibana with username: elastic and default password: student<br>
- From the dropdown menu, select Management → Fleet →Settings → Edit Outputs (Actions)<br>
- Login server via SSH<br>
- Copy ca.crt certificate to /tmp<br>
$ sudo docker cp dshield-elk-es01-1:/usr/share/elasticsearch/config/certs/ca/ca.crt /tmp/.

- Get a copy of Elasticsearch CA trusted fingerprint<br>
$ sudo openssl x509 -fingerprint -sha256 -noout -in /tmp/ca.crt | awk -F"=" {' print $2 '} | sed s/://g

- The output will look like this:<br>
673FB617E15CCCE73F9B647EF99449642A19CFC1D75BF5772047DA99DB950844

- Get Content of Elasticsearch CA Certificate to Apply to Advanced YAML configuration<br>
$ sudo cat /tmp/ca.crt 

Format must be exactly like this. Copy the output of the certificate in Notepad or Notepad++ and format exactly like this.<br>
It needs 2 spaces before certificate_authorities: and the dash (**-**) and it needs 4 spaces from the pipe (**|**) all the way down to the end of -----END CERTIFICATE-----

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

We are going to need this information to setup our fleet server.<br>
Login via SSH to the fleet-server and make sure the dshield-elk-fleet-server-1 is running before setting up our agent:<br>

$ sudo docker start dshield-elk-fleet-server-1<br>
$ sudo docker exec -ti dshield-elk-fleet-server-1 bash<br>

This is an example of what need to be copied to the fleet server. Ensure the fleet server es is: https://es01:9200
Add the bold section after port=8220 because are certificates are self-generated. This will ensure the agent takes the update.
The token and fingerprint will be different then my example:

elastic-agent enroll \\<br>
  --url=https://fleet-server:8220 \\<br>
  --fleet-server-es=https://es01:9200 \\<br>
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE3MDU0NDg3MDMwNTI6NkNxcWlCeTRRVmlhYW0yeldhN3pGZw \\<br>
  --fleet-server-policy=fleet-server-policy \\<br>
  --fleet-server-es-ca-trusted-fingerprint=76DA77DAE186F8CFBA9E87D450D5419B68E2555A9BD57795611C0545ED0BF03F \\<br>
  --fleet-server-port=8220 \\<br>
  **--certificate-authorities=/certs/ca/ca.crt \\<br>
  --fleet-server-es-ca=/certs/es01/es01.crt \\<br>
  --fleet-server-cert=/certs/fleet-server/fleet-server.crt \\<br>
  --fleet-server-cert-key=/certs/fleet-server/fleet-server.key \\<br>
  --fleet-server-es-insecure**

This will replace your current settings. Do you want to continue? [Y/n]: Y<br>

{"log.level":"info","@timestamp":"2024-01-17T00:00:40.404Z","log.origin":{"file.name":"cmd/enroll_cmd.go","file.line":411},"message":"Generating self-signed certificate for Fleet Server","ecs.version":"1.6.0"}<br>

{"log.level":"info","@timestamp":"2024-01-17T00:00:42.774Z","log.origin":{"file.name":"cmd/enroll_cmd.go","file.line":788},"message":"Fleet Server - Running on policy with Fleet Server integration: fleet-server-policy; missing config fleet.agent.id (expected during bootstrap process)","ecs.version":"1.6.0"}<br>

{"log.level":"info","@timestamp":"2024-01-17T00:00:43.073Z","log.origin":{"file.name":"cmd/enroll_cmd.go","file.line":479},"message":"Starting enrollment to URL: https://a4a1ada63084:8220/","ecs.version":"1.6.0"}<br>

{"log.level":"info","@timestamp":"2024-01-17T00:00:44.152Z","log.origin":{"file.name":"cmd/enroll_cmd.go","file.line":277},"message":"Successfully triggered restart on running Elastic Agent.","ecs.version":"1.6.0"}<br>
_Successfully enrolled the Elastic Agent._

From your current location, verify it installed correctly<br>
$ ./elastic-agent status<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/7739c64e-5c10-4a0c-85e8-7be20749a05f)

In Elastic Management → Fleet, refresh Agents and this is what shows up:

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/144f24f6-2f53-45b2-acaa-41f796efe6a3)

The server is now ready to install Threat Intel Agents to be used in Security (SIEM portion) against the honeypot logs.<br>
The next step is to select Agent policies → Fleet Server Policy → Add integration:<br>
Use this Dashboard to view the metrics collected by elastic-agent:<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/ebb0441a-36b4-454c-acd3-ae6d8262f7d9)


- Select and Add AlienVault OTX (need an API key)<br>
- Select AbuseCH (no API key needed)<br>
- Select Threat Intelligence Utilities<br>
- Select Docker<br>
- Select Kibana<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/64f795cf-e761-42ca-b94a-a79e87b16ee6)

- In Elastic Management → Installed Integration<br>
- Select each of the installed integration, then select Settings and enable the tab to _keep the policy up to date_:<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/f7f8d4d9-f5b3-45b2-849f-cb855bf6b757)

## Configuring Security → Rules

- Select Rules → Detection rules (SIEM) → Add Elastic rules
- Under Search Tags: Rule Type: Indicator Match (4 rules)
- Install and enable those 4 rules
- You can look through the rules and enable those other rules that you want to try against your honeypot data.<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/4fec2d86-208a-465d-8853-9456acc7913f)

## Configure Management → Stack Management → Advanced Settings

Find Elasticsearch Indices and add at the end of the list:<br>
- ,cowrie*<br>
- Save changes for these logs to be analyzed by the SIEM part of ELK.<br>

## Setup webhoneypot.sh Parser

This is a hourly script that extract the logs hourly and Filebeat send them to Logstash<br>
The script is kept in: ~/scripts but can be put where you want. The cronjob runs every hour<br>

## Dump the cowrie web logs every hours
The weblogs are parsed by a cronjob every hour and saved in the honeypot administrator account directory (i.e. ~/webhoneypot) and sent by Filebeat to ELK.<br>
**Note**: For the cronjob to work, _change the path_ from /home/**guy** to your own /home account.

$ crontab -e (add the hour cronjob below to your account)<br>
1 * * * * /home/**guy**/scripts/webhoneypot.sh  > /dev/null 2>1&<br>

# Setup Filebeat on DShield Sensor

After adding the webhoneypot.sh script, add the Filebeat package to the DShield Sensor to send the logs the Elasticsearch.<br>

If use the following to install the Filebeat package using [3] the following commands:<br>

$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -<br>
$ sudo apt-get install apt-transport-https<br>
$ echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list<br>
$ echo "deb https://artifacts.elastic.co/packages/oss-8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list<br>
$ sudo apt-get update && sudo apt-get install filebeat<br>

Download the custom filebeat.yml file that will forward the logs the Elasticsearch:<br>

$ sudo curl https://handlers.sans.edu/gbruneau/elk//DShield/filebeat.yml -o /etc/filebeat/filebeat.yml<br>

- Edit the filebeat.yml file and change the path of the webhoneypot logs to match the cronjob path you just completed.<br>
- Change the IP address to the logstash parser (192.168.25.23) to match the IP used by Logstash:<br>

$ sudo vi /etc/filebeat/filebeat.yml<br>

 # Paths that should be crawled and fetched. Glob based paths.<br>
  paths:<br>
    - /home/guy/webhoneypot/webhoneypot*.json<br>

  output.logstash:<br>
  hosts: ["192.168.25.23:5044"]<br>

## Start Filebeat

$ sudo systemctl enable filebeat<br>
$ sudo systemctl start filebeat<br>
$ sudo systemctl status filebeat<br>

# Interface - Logs DShield Sensor Overview

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/e2f41712-8606-438f-991f-07b48a3cbdb5)

# Useful Docker Commands
$ sudo docker compose rm -f -v (clear setup but need to run up -d again)<br>
$ sudo docker compose up -d (reload container with changes)<br>
$ sudo docker compose up --build -d<br>
$ sudo docker compose up --build --force-recreate -d (force a rebuild if the container hasn't changed)<br>
$ sudo docker compose start/stop<br>
$ sudo docker compose ps (list running containers)<br>
$ sudo docker stats (shows status of container)<br>
$ sudo docker container ls/ps<br>
$ sudo docker stats (shows status of container)<br>
$ sudo docker system prune -a (Remove everything)<br>
$ sudo docker logs dshield-elk-kibana (troubleshooting docker)<br>
$ sudo docker compose logs --follow (debugging)<br>
$ sudo docker compose down --remove-orphans && sudo docker compose up --build -d (Removed or renamed orphan container)

$ sudo docker stop dshield-elk-metricbeat01-1<br>
$ sudo docker stop dshield-elk-logstash01-1<br>
$ sudo docker inspect dshield-elk-logstash01-1<br>

# Login each Container<br>
$ sudo docker exec -ti dshield-elk-es01-1 bash<br>
$ sudo docker exec -ti dshield-elk-logstash01-1 bash<br>
$ sudo docker exec -ti dshield-elk-kibana-1 bash<br>
$ sudo docker exec -ti dshield-elk-fleet-server-1 bash<br>
$ sudo docker exec -ti dshield-elk-cowrie-1 bash<br>


# References
[1] https://isc.sans.edu/tools/honeypot/<br>
[2] https://www.elastic.co/downloads/beats/filebeat<br>
[3] https://www.elastic.co/guide/en/beats/filebeat/8.8/setup-repositories.html#_apt<br>
[4] https://isc.sans.edu/diary/DShield+Honeypot+Activity+for+May+2023/29932<br>
[5] https://isc.sans.edu/diary/DShield+Sensor+JSON+Log+to+Elasticsearch/29458<br>
[6] https://isc.sans.edu/diary/DShield+Sensor+JSON+Log+Analysis/29412<br>
[7] https://github.com/jslagrew/cowrieprocessor/blob/main/submit_vtfiles.py<br>
[8] https://handlers.sans.edu/gbruneau/elastic.htm<br>
[9] https://www.elastic.co/guide/en/fleet/current/secure-connections.html<br>
[10] https://www.docker.elastic.co/<br>
