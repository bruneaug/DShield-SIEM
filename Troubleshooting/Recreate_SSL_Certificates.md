# Updating ELK Components Docker SSL Certificates
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

# Import CA Cert into Workstation

If you are using Windows, you have 2 options to get a copy of the ca.crt file, you can use Windows, you have the option of using scp (command line) or WinSCP to download a copy of the ca.crt file and install it in the workstation. As administrator, import the certificate.

In the ELK server, copy the certificate to your home directory and change the ownership:
```
guy@ubuntu:~$ sudo cp /var/lib/docker/volumes/dshield-elk_certs/_data/ca/ca.crt .
guy@ubuntu:~$ sudo chown guy:guy ca.crt
```
In Windows, transfer a copy of the ca.crt file to your own account <br>
```
C:\Users\guy\Downloads>scp guy@192.168.25.231:~/ca.crt .<br>
guy@192.168.25.231's password:<br>
ca.crt                                     100% 1200     1.1MB/s   00:00<br>
```
From the Downloads directory double-click on certificate: <br>
- Install Certificate<br>
- Select Local Machine <br>
- Select Place all certificates in the following store and Browse<br>
- Select Trusted Root Certification Authorities<br>
- Select OK -> Next -> Finish<br>
- Should show: The Import was successful.<br>

The certificate will now be trusted by the local machine. It is possible the web browser cache may have to be clear to show the lock key.<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/4db225a5-b30f-469a-9fcc-d2bc969694a6)

If you look inside the certificate before login ELK, you can see the hostnames and IPs added to the .env file<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/f2492ec3-71a7-4d04-9c78-e5b9a6f33c7e)


Now you can login Kibana.
