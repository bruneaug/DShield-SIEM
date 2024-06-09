# Removing Current SSL Certificate

$ sudo rm -f /var/lib/docker/volumes/dshield-elk_certs/_data/certs.zip<br>
$ sudo docker compose stop<br>
$ sudo docker compose rm -f -v<br>
$ sudo docker compose up --build -d<br>

After restarting docker, you can review that your changes made it to the certs by looking at this file:<br>
$ sudo cat /var/lib/docker/volumes/dshield-elk_certs/_data/instances.yml<br>

The certs.zip file should now have been updated as well<br>
$ sudo ls -l /var/lib/docker/volumes/dshield-elk_certs/_data/<br>

Login es01 and unzip certs.zip to load the new certificate that contains the correct hostname and IP address.<br>
$ sudo docker exec -ti -u root es01 bash<br>
$ cd config/certs/<br>
$ unzip certs.zip<br>
replace es01/es01.crt? [y]es, [n]o, [A]ll, [N]one, [r]ename:<br>
Select A for all<br>

$ sudo docker compose stop<br>
$ sudo docker compose rm -f -v<br>
$ sudo docker compose up --build -d<br>
