#!/usr/bin/bash
# Guy Bruneau
# Date: 27 Mar 2026
# Version: 0.1

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
scp -P 12222 ubuntu@remoteIP:/srv/log/webhoneypot-$YESTERDAY.json /home/guy/webhoneypot/

# Download cowerie logs
scp -P 12222 ubuntu@remoteIP:/srv/cowrie/var/log/cowrie/cowrie.json.$YESTERDAY  /home/guy/cowrie/

# Download uploaded files - These are scripts and potential malware uploaded by actors/bots
scp -P 12222 ubuntu@remoteIP:/srv/cowrie/var/lib/cowrie/downloads/* /home/guy/download/

