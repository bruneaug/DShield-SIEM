#!/usr/bin/bash
# Guy Bruneau
# Date: 31 Jan 2025
# Version: 0.1

#### This script runs on ELK server

# Change permissions to this script to executable
chmod 755 ~/DShield-SIEM/scripts/cowrie-setup.sh

# Changing the IP in the dshield_sensor JSON mapping file based on the IP of the ELK Server .env file

ELK_IP=`cat ~/DShield-SIEM/.env | grep IPADDRESS | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
sed -i "s/192\.168\.25\.231/$ELK_IP/g" ~/DShield-SIEM/scripts/dshield_sensor_8.*.ndjson



