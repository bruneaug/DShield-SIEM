# Removing Current SSL Certificate
If after setting up ELK you find out your ELK certificates are incorrect, you can rebuild them after updating the .env files in the DShield-SIEM directory.<br>

Review this section **Configure and install DShield ELK**<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/README.md#configure-and-install-dshield-elk

$ sudo rm -f /var/lib/docker/volumes/dshield-elk_certs/_data/certs.zip<br>
$ sudo docker compose stop<br>
$ sudo docker compose rm -f -v<br>
$ sudo docker compose up --build -d<br>

After restarting docker, review and confirm the changes previous added or removed, were included in the certs by reviewing at this file:<br>
$ sudo cat /var/lib/docker/volumes/dshield-elk_certs/_data/instances.yml<br>

The certs.zip file should now have been updated as well with the new date and time of creation<br>
$ sudo ls -l /var/lib/docker/volumes/dshield-elk_certs/_data/<br>

Login in elasticsearch (es01) as root and unzip certs.zip to load the new certificate that contains the updated hostname and IP address.<br>
$ sudo docker exec -ti -u root es01 bash<br>
$ cd config/certs/<br>
$ unzip certs.zip<br>

replace es01/es01.crt? [y]es, [n]o, [A]ll, [N]one, [r]ename: _Select A for all_<br>

$ sudo docker compose stop<br>
$ sudo docker compose rm -f -v<br>
$ sudo docker compose up --build -d<br>

Now you can login Kibana.
