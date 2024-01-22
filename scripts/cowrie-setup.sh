#! /bin/bash

# Guy Bruneau, guybruneau@outlook.com
# Date: 10 Jan 2024
# Version: 1.0

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

# dashboard setup
echo "Setting up Dashboard"
#curl -u elastic:$ELASTIC_PASSWORD -s -H 'kbn-xsrf: true' -XPOST http://kibana:5601/api/saved_objects/_import --form file=@dshield_sensor_8.11.1.ndjson
curl -u elastic:$ELASTIC_PASSWORD -s -H 'kbn-xsrf: true' -XPOST http://kibana:5601/api/saved_objects/_import?overwrite=true --form file=@dshield_sensor_8.11.1.ndjson
