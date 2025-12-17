#!/usr/bin/bash

#### This script runs on ELK server

# This script is used to query the IP list from ISC website

# https://isc.sans.edu/api/threatcategory/research?json

# Transfer logs to ELK server
#0 15 * * * $HOME/scripts/get_researchers.sh > /dev/null 2>1&

YESTERDAY=`date -d "1 day ago" '+%Y-%m-%d'`
2DAYSAGO=`date -d "2 day ago" '+%Y-%m-%d'`

# Using default password to sudo commands: training
# See last command and change training to your own sudo password

PASSWORD="training"

# Download the JSON file

curl  https://isc.sans.edu/api/threatcategory/research?json -o $HOME/scripts/research.json

# Parse the JSON file with just the IP and the type

cat ~/research.json | sed 's/},{/}\n{/g' | tr -d '"{}[]' | sed 's/ipv4:\(.*\),added.*type:\(.*\)/"\1": \2/g' > $HOME/DShield-SIEM/logstash/config/scanners.yml

echo $PASSWORD | sudo -S docker cp $HOME/DShield-SIEM/logstash/config/scanners.yml logstash:/usr/share/logstash/config

/usr/bin/rm -f $HOME/scripts/research.json
