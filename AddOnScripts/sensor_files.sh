#!/usr/bin/bash
# Guy Bruneau
# Date: 27 Mar 2026
# Version: 0.1

# Get the Filebeat configuration files from this location:
# https://github.com/bruneaug/DShield-Sensor

# Copy the filebeat directory to the local filebeat direct to use the default files
# edit the filebeat.yml and update the IP (192.168.25.23) to the IP of your DShiel-SIEM

# Run these 2 test to confirm filebeat can successfully connect to Logstash
# filebeat test config
# filebeat test output

# Replace /home/guy with the location your logs are going to be saved
# mkdir following directories: dshield, webhoneypot, cowrie and downloads where your account is located 
# where the files will be saved when the script run

# This script is part of the ELK server if this is where you want to dowload the logs from the sensor.
# Cronjob to automatically transfer logs daily
# crontab -e 
# Add this command to user cron and save. Make sure the directories exist locally
# It is set at 23:58 to ensure the dshield firewall logs are transferred before they are lost
# 58 23 * * * /home/guy/script/sensor_files.sh > /dev/null 2>1&


# This script is used to download logs from DShield sensor locally to either keep copies
# or to replay into the DShield SIEM.

# Change removeIP to your Cloud sensor IP

#ssh -p '12222' 'ubuntu@remoteIP'

# In ELK server, create SSH Shared Keys and don’t put a password:
# Copy id_rsa.pub over to each sensor(s). Likely the easiest way to copy the public key over might be to scp from DShield sensor.
# ssh-copy-id will send your public key to the DShield sensor and after that you won't need to used a password to remotely login the sensor.

# cd
# ssh-keygen
# ssh-copy-id -p 12222 ubuntu@remoteIP

#!/usr/bin/bash

# Yesterday's date to transfer daily packets
YESTERDAY=`date -d "1 day ago" '+%Y-%m-%d'`
# Previous packets - keep 3 days back
DELETEPACKETS=`date -d "4 day ago" '+%Y-%m-%d'`



# Download iptables
scp -P 12222 ubuntu@remoteIP:/var/log/dshield.log  /home/guy/dshield/

# Download webhoneypot logs
# Make a copy of the file to local directory & change the permissions
# Change /home/ubuntu & ubuntu:ubuntu to your local DShield sensor directory
ssh -p 12222 ubuntu@remoteIP "sudo cp /srv/log/webhoneypot_$YESTERDAY.json /home/ubuntu"
ssh -p 12222 ubuntu@remoteIP "sudo chown ubuntu:ubuntu /home/ubuntuwebhoneypot_$YESTERDAY.json"

scp -P 12222 ubuntu@remoteIP:/home/ubuntu/webhoneypot_$YESTERDAY.json /home/guy/webhoneypot/
# Delete the transferred file form the DShield sensor home user directory
ssh -p 12222 ubuntu@remoteIP "sudo rm -f /home/ubuntu/webhoneypot_$YESTERDAY.json"

# Download cowerie logs
scp -P 12222 ubuntu@remoteIP:/srv/cowrie/var/log/cowrie/cowrie.json.$YESTERDAY  /home/guy/cowrie/

# Download uploaded files to sensor
# WARNING - These are scripts and potential malware uploaded by actors/bots
ssh -p 12222 ubuntu@remoteIP "sudo chmod 664 /srv/cowrie/var/lib/cowrie/downloads/*"
scp -P 12222 ubuntu@remoteIP:/srv/cowrie/var/lib/cowrie/downloads/* /home/guy/downloads/

