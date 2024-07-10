#!/usr/bin/bash

# Guy Bruneau
# Date: 2 July 2024
# Version: 1.0

# This script is used query the cowrie log hashes against the Virustotal data.
# Get the script
# wget https://raw.githubusercontent.com/jslagrew/cowrieprocessor/main/cowrie_malware_enrichment.py

# user cronjob running once a day
# Query cowrie hash logs for the previous  day
# 0 1 * * * /home/guy/scripts/cowrie_vt.sh > /dev/null 2>1&


TODAY=$(date "+%Y-%m-%d")
YESTERDAY=`date -d "1 day ago" '+%Y-%m-%d'`
FILE="/srv/cowrie/var/log/cowrie/cowrie.json.$YESTERDAY"

DIRECTORY=/srv/hash

# Check if directory exist and create it if doesn't
if [ ! -d "$DIRECTORY" ]; then
   mkdir -p "$DIRECTORY"
   echo "Directory '$DIRECTORY' created."

else
        echo "Directory '$DIRECTORY' already exist."
fi

cd $DIRECTORY
rm vt_data cowrie_malware_enrichment.log

/usr/bin/python3 ./cowrie_malware_enrichment.py --vtapi "insert here your own VT API key" --filepath $FILE
