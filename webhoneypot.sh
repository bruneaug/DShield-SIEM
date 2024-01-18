#!/bin/bash

# Guy Bruneau
# Date: 8 Dec 2023
# Version: 0.5

# Setup cronjob to run every hours

# Dump the cowrie web logs every hours
#1 * * * * /home/guy/scripts/webhoneypot.sh  > /dev/null 2>1&

# This script transform the webhoneypot logs to ndjson format before they
# are import by filebeat into Elasticsearch.

# Parse logs per hours into Elasticsearc with this format:
# cat /srv/db/webhoneypot-2023-11-20.json | sed 's/\}\}/}}\n/g' | grep '{"time": "2023-11-20T01:'

# It includes a carriage return after: false}]}}
# This scripts takes:  false}]}}{"time":
# Convert this to:
#  false}]}}
#{"time"
#


DATETIME=$(date -d "1 hour ago" '+%Y-%m-%dT%H')
PREVIOUSDAY=$(date -d "2 hour ago" '+%Y-%m-%dT%H')
#STARTDATE=$(date -d "1 hour ago" '+%m/%d/%Y %H:00:00')
#STARTEPOCH=$(date -d "$STARTDATE" +%s)
TODAY=$(date "+%Y-%m-%d")
YESTERDAY=$(date -d "1 hour ago" '+%Y-%m-%d')
ENDDATE=$(date "+%m/%d/%Y %H:00:00")
ENDEPOCH=$(date -d "$ENDDATE" +%s)
# Parse the grep information
QUOTE='"'
TIMEQUOTE='"time"'
TODAYQUERY="{$TIMEQUOTE: $QUOTE$DATETIME"
YESTERDAYQUERY="{$TIMEQUOTE: $QUOTE$PREVIOUSDAY"
DIRECTORY="$HOME/webhoneypot"
# Check if we are at the end of the day (hour)
#NOW=$(date -d "now" "+%Y-%m-%d %H-:00:00")
#FILENAME=$(date -d "-1 hour" "+%H")

# Check if directory exist and create it if doesn't
if [ ! -d "$DIRECTORY" ]; then
   mkdir -p "$DIRECTORY"
fi

TIME="time='$LASTHOUR'-'$NOW'"

if [ $TODAY = $TODAY ]; then
#cat /srv/db/webhoneypot-$TODAY.json | sed 's/\}\}/}}\n/g' | grep "$TODAYQUERY"
  cat /srv/db/webhoneypot-$TODAY.json | sed 's/\}\}/}}\n/g' | grep "$TODAYQUERY" > $DIRECTORY/webhoneypot-$TODAY.json
else
  cat /srv/db/webhoneypot-$YESTERDAY.json | sed 's/\}\}/}}\n/g' | grep $YESTERDAYQUERY > $DIRECTORY/webhoneypot-$YESTERDAY.json
fi
