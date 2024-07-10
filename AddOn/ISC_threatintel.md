# Setup Filebeat on ELK Server for ISC ThreatIntel
The Internet Storm Center (ISC) receives lots of IP log data about actor activity. This script is used to download and parse that data and import it into Elasticsearch to be used by the SIEM.<br>
The script download (get_iscipintel.sh) download the top 5000 IPs reported on the previous day and import them into Elasticsearch.<br>

### Installing & Configuring Filebeat on ELK server

$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -<br>
$ sudo apt-get install apt-transport-https<br>
$ echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list<br>
$ echo "deb https://artifacts.elastic.co/packages/oss-8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list<br>
$ $ sudo apt-get update && sudo apt-get install filebeat <br>
$ sudo curl https://raw.githubusercontent.com/bruneaug/DShield-SIEM/main/filebeat.yml -o /etc/filebeat/filebeat.yml<br>

$ sudo vi /etc/filebeat/filebeat.yml <br>

output.logstash:<br>
  hosts: ["127.0.0.1:5044"]<br>

$ sudo systemctl enable filebeat<br>
$ sudo systemctl start filebeat<br>
$ sudo systemctl status filebeat<br>

### Installing the Script

$ mkdir $HOME/scripts<br>
$ cd $HOME/scripts<br>
$ wget get_iscipintel.sh<br>

