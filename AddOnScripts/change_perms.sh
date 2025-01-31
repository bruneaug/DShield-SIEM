#!/usr/bin/bash
# Guy Bruneau
# Date: 31 Jan 2025
# Version: 0.1

#### This script runs on ELK server

# Change permissions to these scripts to executable

chmod 755 ~/DShield-SIEM/scripts/cowrie-setup.sh
sudo chown root:root ~/DShield-SIEM/filebeat/filebeat.yml
sudo chmod 644 ~/DShield-SIEM/filebeat/filebeat.yml
sudo chown -R root:root ~/DShield-SIEM/metricbeat/*
sudo chmod 644 ~/DShield-SIEM/metricbeat/metricbeat.yml
sudo chmod -R 644 ~/DShield-SIEM/metricbeat/modules.d/*

# Check if the file exist and if it does, change the IP to ELK Server 

# Changing the IP in the dshield_sensor JSON mapping file based on the IP of the ELK Server

ELK_IP=`cat ~/DShield-SIEM/.env | grep IPADDRESS | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`

if [ ! -e  ~/DShield-SIEM/scripts/dshield_sensor_8.*.ndjson ]; then

   echo "File does not exist"
else
   sed -i "s/192\.168\.25\.231/$ELK_IP/g" ~/DShield-SIEM/scripts/dshield_sensor_8.*.ndjson
fi




