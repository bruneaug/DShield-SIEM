#!/usr/bin/bash

# Guy Bruneau
# Date: 29 Jun 2024
# Version: 1.0

#### This script runs on ELK server

# This script is used to query the IP list from ISC website

# Parsing wget http://isc.sans.edu/api/sources/attacks/2000/2024-06-23?json -O 2024-06-23.json ; cat 2024-06-23.json | tr -d '[]' | sed 's/},{/}\n{/g'  > iscintel-2024-06-23.json

# Transfer logs to ELK server
#0 12 * * * /root/scripts/get_iscipintel.sh> /dev/null 2>1&

YESTERDAY=`date -d "1 day ago" '+%Y-%m-%d'`
2DAYSAGO=`date -d "2 day ago" '+%Y-%m-%d'`
DIRECTORY=$HOME/iscintel
FILE=iscintel-$YESTERDAY.json
FILENAME=$HOME/iscintel/iscintel-$YESTERDAY.json
OLDFILE=$HOME/iscintel/iscintel-$2DAYSAGO.json


# Check if directory exist and create it if doesn't
if [ ! -d "$DIRECTORY" ]; then
   mkdir -p "$DIRECTORY"
   echo "Directory '$DIRECTORY' created."

else
        echo "Directory '$DIRECTORY' already exist."
fi

# Delete previous file
/usr/bin/rm -f $DIRECTORY/*.json


# Get the data
cd $DIRECTORY
wget https://isc.sans.edu/api/sources/attacks/5000/$YESTERDAY?json -O $YESTERDAY.json ; cat $YESTERDAY.json | tr -d '[]' | sed 's/},{/}\n{/g'  > $FILE
