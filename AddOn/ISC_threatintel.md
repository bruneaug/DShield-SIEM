# Setup Filebeat on ELK Server for ISC ThreatIntel
The Internet Storm Center (ISC) receives lots of IP log data about actor activity. This script is used to download and parse that data and import it into Elasticsearch to be used by the SIEM.<br>
The script also download the ECS formatted threat intel from [Rosti](https://rosti.bin.re/feeds).<br>
The script download (get_iscipintel.sh) download the top 5000 IPs reported on the previous day and import them into Elasticsearch.<br>

### Installing & Configuring Filebeat on ELK server
This is automatically installed with the [change_perms.sh](https://raw.githubusercontent.com/bruneaug/DShield-SIEM/refs/heads/main/AddOnScripts/change_perms.sh) which also install the cronjob that runs daily<br>
that runs with this script daily [get_iscipintel.sh](https://raw.githubusercontent.com/bruneaug/DShield-SIEM/refs/heads/main/AddOnScripts/get_iscipintel.sh). The threat intel is downloaded and saved in the **/opt/intel**<br>
directory and owned with the permissions of the local user that run docker.<br>

### Manually Getting Data
If it is important to parse data from a date that wasn't imported, the following command can be used to get that data.<br>
$ sudo su -<br>
\# cd $HOME/iscintel<br>
\# wget http://isc.sans.edu/api/sources/attacks/2000/2024-06-23?json -O 2024-06-23.json ; cat 2024-06-23.json | tr -d '[]' | sed 's/},{/}\n{/g'  > iscintel-2024-06-23.json<br>

# SIEM Alert Activity
![image](https://github.com/user-attachments/assets/67c4da57-ef7c-4d00-b7fd-7ea91eebefb7)
