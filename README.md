# DShield Sensor Log Collection with Elasticsearch
## Introduction
This is fork and a significant update from the initial publication on the ISC Storm Center website by Scott Jensen as a BACS paper and the scripts published in Github.<br>
https://github.com/fkadriver/Dshield-ELK<br>
https://isc.sans.edu/diary/DShield+Sensor+Monitoring+with+a+Docker+ELK+Stack+Guest+Diary/30118<br>

This is a good reference on howto use DShield-SIEM for analysis: https://isc.sans.edu/diary/30962/

## DShield SIEM Network Flow
This provides an overview how the log collection with the DShield sensor is done.<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/DShield-SIEM-Flow.png

# What it is Used For
This docker is custom built to be used with the [DShield Honeypot](https://isc.sans.edu/tools/honeypot/) to collect and parse the logs and collect its data in a visual and easy to search for research purposes. The suggested installation is to install the DShield sensor in a Rasperry using PI Raspbian OS or a system running Ubuntu 20.04 LTS either in your network or in the cloud of your choice.<br>

- This was tested on Ubuntu 22.04 LTS<br>
- Step 1 build Ubuntu<br>
- Step 2 install docker and ELK<br>
- Step 3 install and configure Filebeat on DShield Sensor(s)<br>

# Ubuntu Setup
- Ubuntu 22.04 LTS Live Server 64-Bit<br>
- Minimum 8+ GB RAM<br>
  - If the amount of RAM assigned to each containers (see below) is more than 2GB, consider increasing the server RAM capacity.<br>
- 4-8 Cores<br>
- Minimum 300 GB partition assigned to /var/lib/docker<br>
- Adding a 300 GB to a VM: https://github.com/bruneaug/DShield-SIEM/blob/main/AddOn/Build_a_Docker_Partition.md
## Elastic Packages Installed
### ELK Current Version: 8.14.0 (Updated June 2024)
- Kibana
- Elasticsearch
- Logstash
- Elastic-Agent

**Note**: To update ELK server components, follow these steps:<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/README.md#download-github-update

## Install docker
 $ sudo apt-get install ca-certificates curl gnupg network-manager txt2html<br>
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
$ chmod 754 ~/DShield-SIEM/scripts/cowrie-setup.sh<br>
$ mkdir scripts<br>
$ mv DShield-SIEM/AddOnScripts/parsing_tty.sh scripts<br>
$ mv DShield-SIEM/AddOnScripts/rename_arkime_pcap.sh scripts<br>
$ chmod 754 scripts/*.sh<br>

The parsing_tty.sh script will be configured later in another document.<br>
$ cd ~/DShield-SIEM<br>

**Note**: Before installation, you can edit the .env file to make any derided changes.<br>
    - Current _default password_ for elastic is **student**<br>
Memory Limits in **.env** are the most memory that docker will allocate for each of the ELK containers.<br>
Default to **2147483648** (2GB) but can be expanded if you have the resources<br>

- Update the following variables in the **.env** file to match your ELK server DNS information, hostname, IP and default elastic password if you want to change it: <br>
  - HOSTNAME="ubuntu"
  - DNS_SERVER="9.9.9.9"
  - IPADDRESS="192.168.25.231"
  - ELASTIC_PASSWORD=student
- If you want to change the default nameserver(s), go to the following directory for the files
  - $ cd logstash/pipeline
  - logstash-200-filter-cowrie.conf <br>
  - logstash-201-filter-iptables.conf <br>
  - logstash-202-filter-cowrie-webhoneypot.conf <br>
You can keep these default or edit each files and change them.

Now execute docker compose to build the ELK server applications. <br>
This will build: Kibana, Elasticsearch, elastic-agent, Logstash and load the Cowrie parsers, configuration files and dashboard.<br>

$ sudo docker compose up -d <br>

### Setup Docker Auto-Restart on Reboot
Enable and start the docker service. This will restart DShield-SIEM when the server is rebooted.

$ sudo systemctl enable docker.service<br>
$ sudo systemctl start docker.service<br>

Confirm the docker service is running<br>
$ sudo systemctl status docker.service<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/55df8e2f-6896-497c-b1b8-247196141e6f)

Installation Completed

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/df44cf7d-b105-4188-abe7-983311e313d3)

### Docker Directory Listing
This command shows the list of docker directories in used after all of Elasticsearch components have been installed.<br>
As data gets added to Elasticsearch, you can also monitor either with the command below or within ELK the amount of disk is available for storage.<br>
$ sudo du --human-readable --max-depth 1 --no-dereference --one-file-system /var/lib/docker<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/2f3f3f6d-94a8-4154-b39e-7edaa4086572)

### The following ELK Services are Setup
Using netstat, these 4 services should now be listening.<br>
```
$ netstat -an | grep '9200\|8200\|5601\|5044'
tcp        0      0 0.0.0.0:5601            0.0.0.0:*               LISTEN  ---> Kibana
tcp        0      0 0.0.0.0:8220            0.0.0.0:*               LISTEN  ---> elastic-agent
tcp        0      0 0.0.0.0:9200            0.0.0.0:*               LISTEN  ---> Elasticsearch
tcp        0      0 0.0.0.0:5044            0.0.0.0:*               LISTEN  ---> Logstash
tcp6       0      0 :::5601                 :::*                    LISTEN
tcp6       0      0 :::8220                 :::*                    LISTEN
tcp6       0      0 :::9200                 :::*                    LISTEN
tcp6       0      0 :::5044                 :::*                    LISTEN
```
# Access Kibana Interface
After docker finish installing all the ELK docker components, now it is time to login the ELK stack using your Ubuntu server IP.<br>
- Login Kibana with username: **elastic** and default password _if it hasn't been changed_: **student**<br>
Web Access: https://serverIP:5601

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/6ff32abf-7bf7-4185-8e6d-ae6373d88bea)

# Configuring ELK Stack Management
In order to see the ELK stack health, it is necessary to configure the stack monitoring by navigating to: Management -> Stack Monitoring<br>

- Select "_Or, set up with self monitoring_"<br>
- Monitoring is currently off -> Select: _Turn on monitoring_<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/b41deef3-462c-42de-bf75-c79100833f4b)

# Configuring elastic-agent
The elastic-agent will be used to ingest threat intelligence. It can also be used to do other things that won’t be covered here.<br>
This is an example for the format to setup the fleet-server and the elastic-agent:<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/fleet-server-examples.txt

- From the dropdown menu, select Management → Fleet →Settings → Edit Outputs (Actions)<br>
- Login server via SSH<br>
- Copy ca.crt certificate to /tmp<br>
$ sudo cp /var/lib/docker/volumes/dshield-elk_certs/_data/ca/ca.crt /tmp

- Get a copy of Elasticsearch CA trusted fingerprint<br>
$ sudo openssl x509 -fingerprint -sha256 -noout -in /tmp/ca.crt | awk -F"=" {' print $2 '} | sed s/://g

- The output will look like this:<br>
673FB617E15CCCE73F9B647EF99449642A19CFC1D75BF5772047DA99DB950844

- Get Content of Elasticsearch CA Certificate to Apply to Advanced YAML configuration. Type the command because it doesn't copy well<br>
$ <code>&nbsp;sudo cat /tmp/ca.crt | sed -r 's/\(.*\)/    \1/g'</code>

Follow the example from the Troubleshooting fleet-server-examples guide URL above for the correct format.<br>
_sed_ will add the 4 spaces with the previous command against the CA certificate

- Change the Hosts to: https://es01:9200

After adding the certificate information, save and apply these settings.<br>
Followed by Save and deploy

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/82d3b29f-5398-4f23-afea-63bf6727e087)
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/bc97d11c-b9de-4c26-b24e-17ebed278cd2)

Under Settings, configure the Fleet server hosts by either edit or Add Fleet Server configured as follows:

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/8c6abd5d-a7ba-4183-842a-c98410bd21f0)

Next phase is to Select Agent Policy → Add Agent → Enroll in Fleet → Add Fleet Server

- Provide a Name: es01
- Provide URL: https://fleet-server:8220
- Last: Generate Fleet Server policy
- Select: RPM
Refer to this page for an example of _Fleet-Server SSL Configuration_:<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/fleet-server-examples.txt
  
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/580b3009-0de8-45ba-b297-d4090e2120c9)

We are going to need this information to setup our fleet server.<br>
Login via SSH to the fleet-server and make sure the fleet-server is running before setting up our agent:<br>

$ sudo docker start fleet-server<br>
$ sudo docker exec -ti fleet-server bash<br>
$ ./elastic-agent status (check it is running)<br>
$ ./elastic-agent restart (if it doesn't appear to be running, force a restart, and recheck the status)<br>

This is an example of what need to be copied to the fleet server. Ensure the fleet server es is: https://es01:9200<br>
Add the bold section after port=8220 because are certificates are self-generated. This will ensure the agent takes the update.<br>

The token and fingerprint will be different than this example **_but what is in italic and bolded must be added for the certificat to load_**:<br>

elastic-agent enroll \\<br>
  **_--url=https://fleet-server:8220 \\<br>
  --fleet-server-es=https://es01:9200_** \\<br>
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE3MDU0NDg3MDMwNTI6NkNxcWlCeTRRVmlhYW0yeldhN3pGZw \\<br>
  --fleet-server-policy=fleet-server-policy \\<br>
  --fleet-server-es-ca-trusted-fingerprint=76DA77DAE186F8CFBA9E87D450D5419B68E2555A9BD57795611C0545ED0BF03F \\<br>
  --fleet-server-port=8220 _\\<br>
  **--certificate-authorities=/certs/ca/ca.crt \\<br>
  --fleet-server-es-ca=/certs/es01/es01.crt \\<br>
  --insecure**_

This will replace your current settings. Do you want to continue? [Y/n]: Y<br>

_Successfully enrolled the Elastic Agent._

From your current location, verify it installed correctly<br>
$ ./elastic-agent status<br>
$ ./elastic-agent restart (if you got what appears to be errors, force a restart and check the status)<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/a1bdb5ec-4cf9-4921-b3dc-ff4be0981bc8)

Now that the Fleet Server is connected, close this Windows and lets proceed to the next step.

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/05f1b89e-b081-4ee7-bea6-9c83ae20d350)


In Elastic Management → Fleet, refresh Agents and this is what shows up:

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/f2bb9efd-3c3e-463b-bb9a-a5b3e1bacfd0)

The server is now ready to install Threat Intel Agents to be used in Security (SIEM portion) against the honeypot logs.<br>
The next step is to select Agent policies → Fleet Server Policy → Add integration:<br>
Use this Dashboard to view the metrics collected by elastic-agent:<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/ebb0441a-36b4-454c-acd3-ae6d8262f7d9)


- Select and Add AlienVault OTX (need an API key)<br>
- Select AbuseCH (no API key needed)<br>
- Select Threat Intelligence Utilities<br>
- Elasticsearch<br>
- Select Kibana<br>
- Select Docker<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/64f795cf-e761-42ca-b94a-a79e87b16ee6)

# Fleet Server Policy Example

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/9cbd15e0-1c03-4d79-8cf5-4e0bf1467b18)

- In Elastic Management → Installed Integration<br>
- Select each of the installed integration, then select Settings and enable the tab to _keep the policy up to date_:<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/f7f8d4d9-f5b3-45b2-849f-cb855bf6b757)

## Configuring Security → Rules

- Select Rules → Detection rules (SIEM) → Add Elastic rules
- Under Search Tags: Rule Type: Threat Intel (add at the minimum those 4 rules)
- Install and enable those 4 rules
  - Threat Intel IP Address Indicator Match
  - Threat Intel Windows Registry Indicator Match
  - Threat Intel Hash Indicator Match
  - Threat Intel URL Indicator Match
- You can look through the rules and enable those other rules that you want to try against your honeypot data.<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/b45ba835-2eb9-4246-97b1-160f3c6273d8)

## Review the Activity Captured by the Rules in Alert trend
If some of the threat intel above were added to the elastic-agent, and cowrie* was added to the Management -> Advanced Settings during the initial installation, it can now track rules that match in the alert trends of the SIEM part of the ELK stack.<br>
This is the output from Management → Stack Management → Advanced Settings<br>
 ![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/6112efdc-954e-4377-8a8e-31c005f54a18)

 If any threat intel match, the SIEM will display the following activity that can now be investigated:<br>
 
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/4c2d50c9-5776-432d-8ca3-1fcc2306f2f1)
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/09319047-e0bf-4377-a1e9-72b2fb08c893)


# Setup Filebeat on DShield Sensor - Logs to ELK

After adding the webhoneypot.sh script, add the Filebeat package to the DShield Sensor to send the logs the Elasticsearch.<br>

Use the following steps to install Filebeat using the following commands taken from this reference [3]: <br>

$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -<br>
$ sudo apt-get install apt-transport-https<br>
$ echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list<br>
$ echo "deb https://artifacts.elastic.co/packages/oss-8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list<br>
$ sudo apt-get update && sudo apt-get install filebeat elastic-agent softflowd<br>

Download the custom filebeat.yml file that will forward the logs the Elasticsearch:<br>

$ sudo curl https://raw.githubusercontent.com/bruneaug/DShield-SIEM/main/filebeat.yml -o /etc/filebeat/filebeat.yml<br>

- Edit the filebeat.yml and change the IP address to the logstash parser (192.168.25.23) to match the IP used by Logstash:<br>
$ sudo vi /etc/filebeat/filebeat.yml<br>

  output.logstash:<br>
  hosts: ["192.168.25.23:5044"]<br>
  
## Start Filebeat

$ sudo systemctl enable filebeat<br>
$ sudo systemctl start filebeat<br>
$ sudo systemctl status filebeat<br>
$ sudo systemctl enable elastic-agent<br>
$ sudo systemctl start elastic-agent<br>
$ sudo systemctl enable softflowd<br>
$ sudo systemctl start softflowd<br>

### Filebeat Tracking File
Filebeat tracks the events it has processed with a file located called **log.json**, if deleted, all the events that were previous sent to Elasticsearch will be reprocessed when filebeat is restarted.<br>
The location of this file:<br>
$ cd /var/lib/filebeat/registry/filebeat 

## Want to add Elastic-Agent to other Devices?
Follow this step-by-step documents to install the elastic-agent to the DShield sensor<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/Configure-Elastic-Agent.pdf

# Interface - Logs DShield Sensor Overview
To access the Dashboard select Analytics -> Dashboard -> 	**[Logs DShield Sensor] Overview**<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/5e5aaa4d-a4b6-40bc-98ca-5bae46373c9c)

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/8a1f4aeb-2a93-412f-9c0b-06e491a11cee)

# Starting ELK after a Reboot
This script will start all the ELK components and if installed, the Arkime services.

Install startelk.tgz tarball to ELK server as follow:<br>
$ cd ~/DShield-SIEM/AddOn<br>
$ sudo tar zxvf startelk.tgz -C /

## Edit the Script and Update the User Account Password

$ sudo vi /etc/init.d/startelk.sh

The script is configured with the default password to sudo: **training**<br>
You need to change it to the account's password in use.<br>
You need to change the account under which location DShield-SIEM is located.<br>

PASSWORD="**training**"
ELK="**/home/guy/**DShield-SIEM"

# Useful Docker Commands
$ sudo docker compose rm -f -v (clear setup but need to run up -d again)<br>
$ sudo docker compose up -d (reload container with changes)<br>
$ sudo docker compose up --build -d<br>
$ sudo docker compose up --build --force-recreate -d (force a rebuild if the container hasn't changed)<br>
$ sudo docker compose start/stop<br>
$ sudo docker compose ps (list running containers)<br>
$ sudo docker stats (shows status of container)<br>
$ sudo docker container ls/ps<br>
$ sudo docker network ls (network listing)<br>
$ sudo docker stats (shows status of container)<br>
$ sudo docker system prune -a (Remove everything)<br>
$ sudo docker logs kibana (troubleshooting docker)<br>
$ sudo docker compose logs --follow (debugging)<br>
$ sudo docker compose down --remove-orphans && sudo docker compose up --build -d (Removed or renamed orphan container)<br>
$ sudo docker rm -f cowrie (remove a container)<br>
$ sudo docker system df (Check docker usage)<br>
$ sudo du --human-readable --max-depth 1 --no-dereference --one-file-system /var/lib/docker (Shows a breakdown of docker filesystem)<br>
$ sudo docker builder prune (Clear the build cache if > 0)<br>


$ sudo docker stop fleet-server<br>
$ sudo docker restart logstash  (restart logstash service)<br>
$ sudo docker logs logstash (looking at debugging information)<br>
$ sudo docker inspect logstash<br>

# Download Github Update
$ cd DShield-SIEM<br>
$ sudo docker compose stop<br>
Edit the .env and reset your your hostname & IP address variables. The other option is to manually update to the new version and **skip git pull**<br>.
$ git pull (Update the code from Github)<br>
$ sudo docker compose rm -f -v<br>
$  sudo docker compose up --build -d
### Remove a Container that Fail to Start
$ sudo docker inspect logstash

# Login each Container<br>
$ sudo docker exec -ti es01 bash<br>
$ sudo docker exec -ti logstash bash<br>
$ sudo docker exec -ti kibana bash<br>
$ sudo docker exec -ti fleet-server bash<br>
$ sudo docker exec -ti cowrie bash<br>

# Copying Files Between Docker & Local User
$ sudo docker cp  server:/usr/share/elastic-agent/elastic-agent.yml .<br>
$ sudo docker cp elastic-agent.yml  fleet-server:/usr/share/elastic-agent/

# Information on Elastic with the Console
These command are run from the Dev Tool -> Console<br>

GET _nodes/http?pretty	(Get a list and information of all the nodes)<br>
GET _security/_authenticate<br>

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
