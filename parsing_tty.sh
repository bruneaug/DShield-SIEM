#!/usr/bin/bash

# Guy Bruneau
# Date: 25 Jan 2024
# Version: 1.0

#### This script runs on ELK server

# This script is used to remotely contact a DShield sensor to 
# convert the ttylogs to an html format. After the remote script
# is done running on the previous hour, the parsed ttylogs are
# then transfered to the ELK server to be access in Kibana when needed.

# For this script to work, create SSH shared keys without putting a password
# when asked. Copy the public key to the DShield sensor and test you can
# SSH to it to ensure the script can login without user interaction.

# This is the cronjob to parse and copy the ttylogs every hours

# Transfer logs to ELK server
# 1 * * * * ~/scripts/parsing_tty.sh > /dev/null 2>1&

# Delete the previously processed ttylogs
ssh -p 12222 guy@192.168.25.165 "cd ~/ttylog; rm *.html"

# SSH to the sensor and parse the logs
ssh -p 12222 guy@192.168.25.165 "cd ~/scripts;bash ./ttylog.sh"

# scp to the sensor and transfer the logs to the ELK webserver
scp -P 12222 guy@192.168.25.165:~/ttylog/* /var/www/html

