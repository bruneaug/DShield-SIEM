#!/usr/bin/bash

# Guy Bruneau
# Date: 12 Mar 2024
# Version: 1.0

# This script is used to keep a copy of the iptables.log daily logs.

# root cronjob running once a day
# Copy the daily iptables logs at the end of the day
# 58 23 * * * /home/guy/scripts/copy_iptables.sh > /dev/null 2>1&


TODAY=$(date "+%Y-%m-%d")
YESTERDAY=`date -d "1 day ago" '+%Y-%m-%d'`

DIRECTORY="/srv/NSM/iptables"

# Check if directory exist and create it if doesn't
if [ ! -d "$DIRECTORY" ]; then
   mkdir -p "$DIRECTORY"
   echo "Directory '$DIRECTORY' created."

else
        echo "Directory '$DIRECTORY' already exist."
fi


/usr/bin/cp /var/log/dshield.log $DIRECTORY/dshield-$TODAY.log
