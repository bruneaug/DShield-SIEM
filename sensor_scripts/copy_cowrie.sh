#!/usr/bin/bash

# Guy Bruneau
# Date: 12 Mar 2024
# Version: 1.0

# This script is used to keep a copy of the cowrie, download and webhoneypot daily logs.

# root cronjob running once a day
# Copy the daily cowrie & webhoneypot logs at the end of the day
# 0 2 * * * /home/guy/scripts/copy_cowrie.sh > /dev/null 2>1&

TODAY=$(date "+%Y-%m-%d")
YESTERDAY=`date -d "1 day ago" '+%Y-%m-%d'`

DIRECTORY="/srv/NSM/cowrie"
DIRECTORY1="/srv/NSM/webhoneypot"
DIRECTORY2="/srv/NSM/downloads"


# Check if directory exist and create it if doesn't

if [ ! -d "$DIRECTORY" ]; then
   mkdir -p "$DIRECTORY"
   echo "Directory '$DIRECTORY' created."

else
        echo "Directory '$DIRECTORY' already exist."
fi

/usr/bin/cp /srv/cowrie/var/log/cowrie/cowrie.json.$YESTERDAY $DIRECTORY

# Check if directory exist and create it if doesn't

if [ ! -d "$DIRECTORY1" ]; then
   mkdir -p "$DIRECTORY1"
   echo "Directory '$DIRECTORY1' created."

else
        echo "Directory '$DIRECTORY1' already exist."
fi

/usr/bin/cp /srv/db/webhoneypot-$YESTERDAY.json $DIRECTORY1

# Check if directory exist and create it if doesn't

if [ ! -d "$DIRECTORY2" ]; then
   mkdir -p "$DIRECTORY2"
   echo "Directory '$DIRECTORY2' created."

else
        echo "Directory '$DIRECTORY2' already exist."
fi

/usr/bin/cp /srv/cowrie/var/lib/cowrie/downloads/* $DIRECTORY2
