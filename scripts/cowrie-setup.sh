#!/usr/bin/bash

# Guy Bruneau, guybruneau@outlook.com
# Date: 10 Jan 2024
# Version: 1.0
# Date: 22 Jun 2024
# Version: 1.5
# Added cowrie.vt_data index & policy
# Date: 9 July 2024
# Version: 1.6
# Added ISC threatintel data
# Date: 10 July 2024
# Version: 1.7
# Added SIEM Detection Rule
# Date: 12 August 2024
# Version: 1.8
# Added remove command to delete the dashboard mapping file after it has been removed.
# Date: 4 February 2025
# Version: 1.9
# Added Rosti ThreatIntel

# All the policies have been updated to reflect the changes in the DShield log collection.
# This is a significant update from the initial publication on the ISC Storm Center website
# by Scott Jensen as a BACS paper and the scripts published in Github.
# https://github.com/fkadriver/Dshield-ELK
# https://isc.sans.edu/diary/DShield+Sensor+Monitoring+with+a+Docker+ELK+Stack+Guest+Diary/30118

# This script now load all the defaults for the 3 cowrie collected logs into Elasticsearch.
# It also includes some minor modification of the docker-compose.yml script.

echo "Setting up environment variables"
export scriptdir='/usr/share/scripts'
echo $scriptdir

export curlcmd='curl --cacert /usr/share/config/certs/ca/ca.crt -u elastic:'$ELASTIC_PASSWORD
echo $curlcmd
#$curlcmd -H 'Content-Type: application/json' -XGET https://es01:9200/_cluster/health?pretty

echo "changing directory"
cd $scriptdir

# cowrie setup
echo "Setting up cowrie"
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_ilm/policy/cowrie --data-binary @cowrie-policy.json; echo
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_index_template/cowrie --data-binary @cowrie-index.json; echo

# cowrie-dshield setup
echo "Setting up cowrie.dshield"
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_ilm/policy/cowrie.dshield  --data-binary @cowrie-dshield-policy.json; echo
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_index_template/cowrie.dshield --data-binary @cowrie-dshield-index.json; echo

echo "Setting up cowrie.webhoneypot"
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_ilm/policy/cowrie.webhoneypot --data-binary @cowrie-webhoneypot-policy.json; echo
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_index_template/cowrie.webhoneypot --data-binary @cowrie-webhoneypot-index.json; echo

echo "Setting up ti.iscintel"
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_ilm/policy/ti.iscintel --data-binary @ti.iscintel-policy.json; echo
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_index_template/ti.iscintel --data-binary @ti.iscintel-index.json; echo

echo "Setting up ti.rostiintel"
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_ilm/policy/ti.rostiintel --data-binary @ti.rostiintel-policy.json; echo
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_index_template/ti.rostiintel --data-binary @ti.rostiintel-index.json; echo

echo "Setting up cowrie.vt_data"
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_ilm/policy/cowrie.vt_data --data-binary @cowrie.vt_data-policy.json; echo
$curlcmd -s -H 'Content-Type: application/x-ndjson' -XPUT https://es01:9200/_index_template/cowrie.vt_data --data-binary @cowrie.vt_data-index.json; echo

# Dashboard setup
echo "Setting up Dashboard"
#curl -u elastic:$ELASTIC_PASSWORD -s -H 'kbn-xsrf: true' -XPOST https://kibana:5601/api/saved_objects/_import --form file=@dshield_sensor_8.11.1.ndjson
#curl -u elastic:$ELASTIC_PASSWORD -s -H 'kbn-xsrf: true' -XPOST https://kibana:5601/api/saved_objects/_import?overwrite=true --form file=@dshield_sensor_8.11.1.ndjson
$curlcmd -s -H 'kbn-xsrf: true' -XPOST https://kibana:5601/api/saved_objects/_import?overwrite=true --form file=@dshield_sensor_8.15.3.ndjson

# Detection SIEM Rules setup
echo "Setting up SIEM Detection Rule for Cowrie Activity"
$curlcmd -s -H 'kbn-xsrf: true' -XPOST https://kibana:5601/api/detection_engine/rules/_import?overwrite=true --form file=@Threat_Intel_Indicator_Match_Cowrie.ndjson
$curlcmd -s -H 'kbn-xsrf: true' -XPOST https://kibana:5601/api/detection_engine/rules/_import?overwrite=true --form file=@threat_Intel_IP_Address_Indicator_Match_ISC_ThreatIntel.ndjson

# Delete Mapping File after it has been loaded in Kibana
# This prevent overwriting changes made in the mapping file until the next update
rm dshield_sensor*.ndjson
