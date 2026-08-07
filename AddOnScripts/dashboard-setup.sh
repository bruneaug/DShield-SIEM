#!/bin/bash

# Guy Bruneau, guybruneau@outlook.com
# Date: 6 Aug 2026
# Version: 1.0

# This script now load all the defaults dashboard and SIEM custom signatures in DShield SIEM.

echo "Setting up environment variables"
dashboard="$HOME/DShield-SIEM/configuration"
echo $scriptdir
# Get a copy of the elastic password from the .env file
ELASTIC_PASSWORD=`grep ELASTIC_PASSWORD ~/DShield-SIEM/.env | sed 's/ELASTIC_PASSWORD=//g'`

export curlcmd='curl -u elastic:'$ELASTIC_PASSWORD
echo $curlcmd

echo "changing directory"
cd $dashboard

# Dashboard setup
echo "Setting up Dashboard"
#curl -u elastic:$ELASTIC_PASSWORD -s -H 'kbn-xsrf: true' -XPOST https://kibana:5601/api/saved_objects/_import --form file=@dshield_sensor_8.11.1.ndjson
#curl -u elastic:$ELASTIC_PASSWORD -s -H 'kbn-xsrf: true' -XPOST https://kibana:5601/api/saved_objects/_import?overwrite=true --form file=@dshield_sensor_8.11.1.ndjson
$curlcmd -s -H 'kbn-xsrf: true' -XPOST https://$HOSTNAME/api/saved_objects/_import?overwrite=true --form file=@dshield_sensor_8.19.15.ndjson

# Detection SIEM Rules setup
echo "Setting up SIEM Detection Rule for Cowrie Activity"
$curlcmd -s -H 'kbn-xsrf: true' -XPOST https://$HOSTNAME/api/detection_engine/rules/_import?overwrite=true --form file=@Threat_Intel_Indicator_Match_Cowrie.ndjson
$curlcmd -s -H 'kbn-xsrf: true' -XPOST https://$HOSTNAME/api/detection_engine/rules/_import?overwrite=true --form file=@threat_Intel_IP_Address_Indicator_Match_ISC_ThreatIntel.ndjson

