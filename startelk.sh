!/bin/bash

# Guy Bruneau
# Date: 4 Jan 2023
# Version: 1.0

# References: 
# https://www.elastic.co/blog/getting-started-with-the-elastic-stack-and-docker-compose
# https://github.com/fkadriver/Dshield-ELK/tree/main

# Used to activate Elasticsearch

# Using default password to sudo commands: student 

export HISTIGNORE='*sudo -S*'
echo "Starting the ELK components..."

echo "Increasing virtual memory to 262144..."
echo student | sudo -S -k sysctl -w vm.max_map_count=262144

cd ~/Dshield-ELK
echo student | sudo -S -k docker compose up -d

echo "Login http://IP:5601 with user: elastic and password: student"