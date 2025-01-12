# Useful Docker Commands
$ sudo docker compose rm -f -v (clear setup but need to run up -d again)<br>
$ sudo docker compose up -d (reload container with changes)<br>
$ sudo docker compose up --build -d<br>
$ sudo docker compose up --build --force-recreate -d (force a rebuild if the container hasn't changed)<br>
$ sudo docker compose start/stop<br>
$ sudo docker compose ps (list running containers)<br>
$ sudo docker container ls/ps<br>
$ sudo docker network ls (network listing)<br>
$ sudo docker stats (shows status of container)<br>
$ sudo docker system prune -a (Remove everything)<br>
$ sudo docker logs kibana (troubleshooting docker)<br>
$ sudo docker compose logs --follow (debugging)<br>
$ sudo docker compose down --remove-orphans && sudo docker compose up --build -d (Removed or renamed orphan container)<br>
$ sudo docker rm -f cowrie (remove a container)<br>
$ sudo docker system df (Check docker usage)<br>
$ sudo du --human-readable --max-depth 1 --no-dereference --one-file-system /var/lib/docker (Shows a breakdown of docker filesystem)<br>
$ sudo docker builder prune (Clear the build cache if > 0)<br>

# Specific Docker Commands
$ sudo docker stop fleet-server<br>
$ sudo docker restart logstash  (restart logstash service)<br>
$ sudo docker stop kibana<br>
$ sudo docker start kibana<br>
$ sudo docker restart kibana (restart kibana service)<br>
$ sudo docker logs logstash (looking at debugging information)<br>
$ sudo docker inspect logstash<br>

# Removing a Docker Container
The first command to run is to list the container volumes<br>
```sudo docker volume ls```

The next command is to remove the target container<br>
```sudo docker volume rm  dshield-elk_fleetserverdata```

The output looks like this:<br>
![image](https://github.com/user-attachments/assets/2339589a-df15-4b0a-b4a1-80060d06fa15)

# Docker Container Error

Check Docker Stats first like it is shown below (Docker Stats)<br>

These command should kill the container that won't stop.<br>
Try to start the containers in debug mode:<br>
![image](https://github.com/user-attachments/assets/e1b5bdf6-3964-419c-9525-424f5ff4eff3)

````
sudo docker compose up
````
If you see an error, you need to kill all of the running dockers<br>
````
sudo docker compose stop
sudo docker compose kill
sudo docker compose start
````

# Docker Stats
$ sudo docker stats (shows status of container)<br>
![image](https://github.com/user-attachments/assets/04f0bb31-8184-45b2-ab45-f1fca35fac14)

# Update DShield ELK to the Latest Version
Using **git stash** and **git stash pop** will backup your local changes (i.e. .env and any other files) and restore them after the update.<br>
These two commands should have preserved the following files permissions from your original installation<br>
chmod 754 ~/DShield-SIEM/scripts/cowrie-setup.sh<br>
sudo chown root:root ~/DShield-SIEM/filebeat/filebeat.yml<br>
sudo chmod 644 ~/DShield-SIEM/filebeat/filebeat.yml<br>

````
cd DShield-SIEM
sudo docker compose stop
git stash
git pull
git stash pop
sudo docker compose up --build -d
````
If you get any errors after restarting the docker, rerun the following commands after stopping the docker</br)
````
sudo docker compose stop
sudo docker compose rm -f -v
sudo docker compose up --build -d
````

### Removing a Container that Fail to Start
$ sudo docker inspect logstash

# Update DShield ELK Fails to Download
The following commands should download the latest update:</br>
<pre>
$ guy@ubuntu:~/DShield-SIEM$ git pull
Updating 44f37f4..4f83ad1
error: Your local changes to the following files would be overwritten by merge:
        scripts/cowrie-setup.sh
Please commit your changes or stash them before you merge.
Aborting

guy@ubuntu:~/DShield-SIEM$
$ guy@ubuntu:~/DShield-SIEM$ git fetch --all
Fetching origin
$ guy@ubuntu:~/DShield-SIEM$ git reset --hard origin/main
HEAD is now at 4f83ad1 Update ISC_threatintel.md
$ guy@ubuntu:~/DShield-SIEM$ git pull
Already up to date.
$ guy@ubuntu:~/DShield-SIEM$ chmod 755 scripts/cowrie-setup.sh
</pre>

## Removing all Docker Images
Using this script will remove everything installed in docker<br>
[https://github.com/jwasham/docker-nuke/blob/master/docker-nuke.sh](https://github.com/jwasham/docker-nuke/tree/master)

# Login each Container<br>
$ sudo docker exec -ti es01 bash<br>
$ sudo docker exec -ti logstash bash<br>
$ sudo docker exec -ti kibana bash<br>
$ sudo docker exec -ti fleet-server bash<br>
$ sudo docker exec -ti filebeat bash<br>
$ sudo docker exec -ti cowrie bash<br>

# Copying Files Between Docker & Local User
$ sudo docker cp  server:/usr/share/elastic-agent/elastic-agent.yml .<br>
$ sudo docker cp elastic-agent.yml  fleet-server:/usr/share/elastic-agent/
