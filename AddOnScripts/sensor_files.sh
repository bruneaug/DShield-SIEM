#!/usr/bin/bash
# Guy Bruneau
# Date: 27 Mar 2026
# Version: 0.1

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
ssh -p 12222  ubuntu@emoteIP "sudo cp /srv/logwebhoneypot-$YESTERDAY.json /home/ubuntu"
ssh -p 12222  ubuntu@emoteIP "sudo chown ubuntu:ubuntu /home/ubuntuwebhoneypot-$YESTERDAY.json"

scp -P 12222 ubuntu@emoteIP:/home/ubuntu/webhoneypot-$YESTERDAY.json /home/guy/webhoneypot/
# Delete the transferred file form the DShield sensor home user directory
ssh -p 12222  ubuntu@emoteIP "sudo rm -f /home/ubuntu/webhoneypot-$YESTERDAY.json"

# Download cowerie logs
scp -P 12222 ubuntu@remoteIP:/srv/cowrie/var/log/cowrie/cowrie.json.$YESTERDAY  /home/guy/cowrie/

# Download uploaded files to sensor
# WARNING - These are scripts and potential malware uploaded by actors/bots
ssh -p 12222 ubuntu@emoteIP "sudo chmod 664 /srv/cowrie/var/lib/cowrie/downloads/*"
scp -P 12222 ubuntu@remoteIP:/srv/cowrie/var/lib/cowrie/downloads/* /home/guy/downloads/

