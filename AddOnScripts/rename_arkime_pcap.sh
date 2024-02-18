#!/usr/bin/bash

# Guy Bruneau
# Date: 17 Feb 2024
# Version: 1.0

# Daemonlogger saves the files in this format: daemonlogger.pcap.1707945546
# For Arkime to process the files it needs to end with .pcap
# daemonlogger_1707945546.pcap

# Copy from the DShield sensor(s) the pcap from damonlogger capture
# scp to the sensor and transfer the logs to the ELK webserver

# Transfer logs to ELK server
# 0 1 * * * /home/guy/scripts/rename_arkime_pcap.sh > /dev/null 2>1&

# Using default password to sudo commands: training
# See last command and change training to your own sudo password

PASSWORD="training"

export HISTIGNORE='*sudo -S*'
echo "Importing pcap files to ELK server..."

SENSOR='192.168.25.105'
YESTERDAY=`date -d "1 day ago" '+%Y-%m-%d'`
DIRECTORY=$HOME/pcap

# Check if directory exist and create it if doesn't
if [ ! -d "$DIRECTORY" ]; then
   mkdir -p "$DIRECTORY"
   echo "Directory '$DIRECTORY' created."

else
        echo "Directory '$DIRECTORY' already exist."
fi

# Remove previously processed files
/usr/bin/rm -f $HOME/pcap/*

# Transfer pcap files from DShield sensor(s). If more than one sensor exists,
# add new scp commands.

scp -P 12222 guy@$SENSOR:/srv/NSM/dailylogs/$YESTERDAY/daemonlogger* $HOME/pcap

# Rename the daemonlogger files to end with pcap

for f in $DIRECTORY/daemonlogger*; do

  mv -- "$f" "`echo $f | sed "s/\(.*\)\.\(.*\)\.\(.*\)/\1_\3.\2/g"`";

done

# Import the file(s) into Arkime

echo $PASSWORD | sudo -S -k /opt/arkime/bin/capture --insecure --config /opt/arkime/etc/config.ini --host es01 --pcapdir $DIRECTORY --skip --recursive 

