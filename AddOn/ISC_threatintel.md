# Setup Filebeat on ELK Server for ISC ThreatIntel
The Internet Storm Center (ISC) receives lots of IP log data about actor activity. This script is used to download and parse that data and import it into Elasticsearch to be used by the SIEM.<br>
The script download (get_iscipintel.sh) download the top 5000 IPs reported on the previous day and import them into Elasticsearch.<br>

### Installing & Configuring Filebeat on ELK server

$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -<br>
$ sudo apt-get install apt-transport-https<br>
$ echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list<br>
$ echo "deb https://artifacts.elastic.co/packages/oss-8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list<br>
$ sudo apt-get update && sudo apt-get install filebeat <br>
$ sudo curl https://raw.githubusercontent.com/bruneaug/DShield-SIEM/main/filebeat.yml -o /etc/filebeat/filebeat.yml<br>

$ sudo vi /etc/filebeat/filebeat.yml <br>

output.logstash:<br>
  hosts: ["127.0.0.1:5044"]<br>

$ sudo systemctl enable filebeat<br>
$ sudo systemctl start filebeat<br>
$ sudo systemctl status filebeat<br>

### Installing the Script

$ sudo su -<br>
\# mkdir $HOME/scripts<br>
\# cd $HOME/scripts<br>
\# wget https://raw.githubusercontent.com/bruneaug/DShield-SIEM/main/AddOnScripts/get_iscipintel.sh<br>
\# chmod 755 get_iscipintel.sh

### Setup Cronjob

\# crontab -e<br>
Add the to following:<br>

\# Transfer logs to ELK server<br>
0 12 * * * /root/scripts/get_iscipintel.sh> /dev/null 2>1&<br>

### Manually Getting Data
If it is important to parse data from a date that wasn't imported, the following command can be used to get that data.<br>
$ sudo su -<br>
\# cd $HOME/iscintel<br>
\# wget http://isc.sans.edu/api/sources/attacks/2000/2024-06-23?json -O 2024-06-23.json ; cat 2024-06-23.json | tr -d '[]' | sed 's/},{/}\n{/g'  > iscintel-2024-06-23.json<br>
