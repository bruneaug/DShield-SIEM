# Viewing TTY Logs with Lighttpd

This section provides the steps to convert the ttylogs captured by the DShield sensor into an HTML formatted document that can be accessed from Kibana interface.<br>

Enable tty logging in each DShield sensors:

guy@picollector: sudo vi  /srv/cowrie/cowrie.cfg<br>
Search for ttylog = false change to: ttylog = true<br>
Default ttylog → /srv/cowrie/var/lib/cowrie/tty<br>
$ sudo systemctl restart isc-agent<br>
$ sudo /srv/dshield/status.sh<br>

Install txt2html to convert the ttylogs to an html format to have to ability to access them from ELK<br>
$ sudo apt-get install txt2html<br>

Install lighttpd in the ELK server

$ sudo apt-get install lighttpd<br>
$ sudo systemctl enable lighttpd<br>
$ sudo systemctl start lighttpd<br>

Log location: /var/www/html

$ ls -la /var/www/html<br>
$ sudo chown -R guy:guy /var/www/html<br>
$ ls -l /var/www<br>

Confirm the webserver is accessible, that your account is now the owner of the html directory and running before moving the default index out of the default directory<br>
Using browser access: http://elk
$ mv /var/www/html/index.lighttpd.html .<br>

Configure TTYLog in Kibana

Management -> Kibana -> Data Views -> cowrie*<br>
Edit TTYLog and change the IP 192.168.25.231 to your ELK server IP or Name<br>
 

In ELK server, create SSH Shared Keys and don’t put a password:

$ ssh-keygen<br>
Copy id_rsa.pub over to each sensor(s). Likely the easiest way to copy the public key over might be to scp from DShield sensor. <br>
$ scp guy@192.168.25.231:/home/guy/.ssh/id_rsa.pub .<br>
$ cat id_rsa.pub >> .ssh/authorized_keys<br>
$ rm id_rsa.pub<br>

Test SSH between the ELK server to DShield sensor

$ ssh -l guy 192.168.25.165 -p 12222<br>
Confirm the authentication to allow shared keys to work:<br>
 
Next time you ssh it will log the client automatically in the DShield sensor. This is important for the ELK server to transfer the logs hourly.<br>
Setup DShield Sensor for TTYLogs to HTML Format<br>

There are 2 scripts provided for the sensor<br>

•	replayttylog.sh	→ Used when setting up TTYLogs parsing for the first time<br>
•	ttylog.sh → Runs on a hourly cronjob<br>

If the sensor has been running for a while, un replayttylog.sh until it is completed. This could take a while depending on the number of logs is currently stored. The converted hashes will be stored in the home directory in \~/ttylog. <br>
$ mkdir scripts<br>
$ cd scripts<br>
$ curl https://raw.githubusercontent.com/bruneaug/DShield-SIEM/main/sensor_scripts/replayttylog.sh -o replayttylog.sh<br>
$ curl https://raw.githubusercontent.com/bruneaug/DShield-SIEM/main/sensor_scripts/ttylog.sh -o ttylog.sh<br>
$ chmod 755 *.sh<br>
$ ./replayttylog.sh<br>

When the script finish to run, it is time to manually transfer the logs to the Elastic server.<br>

### Setup Elastic Server for TTYLogs Transfer<br>
The script has completed the log conversion to HTML, the Elastic server should be ready to receive the logs (we assume the webserver is setup as per above) and manually transfer them via scp to ELK:<br>

$ scp -P 12222 guy@192.168.25.165:~/ttylog/* /var/www/html<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/fb3b7e87-c77f-4635-99b0-0bcef51d9b85)

You can also confirm that you can view the html logs by taking one of the html files:
 
The last step is to enable the hourly cronjob on the server to convert and transfer the TTYLogs over to the web server. First is to download the ELK server script to the elastic server:<br>
$ cd scripts<br>
$ mv ~/DShield-SIEM/parsing_tty.sh .<br>
$ chmod 755 parsing_tty.sh<br>

Edit the parsing_tty.sh script and change the IP address 192.168.25.105 to the IP address of the DShield sensor and save the change:<br>
$ vi parsing_tty.sh<br>
$ crontab -e<br>
1 * * * * ~/scripts/parsing_tty.sh > /dev/null 2>1&<br>
This complete converting to HTML the ttylogs and having them available from the ELK server. <br>

## Accessing TTYLogs from Kibana
In Kibana, lookf for the Top 10 TTY Logs summary and just select TTYLog to go to the webserver page containing the log.

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/8981493b-553b-464e-8fc8-a9ff4a39e92e)

## Change the URL IP 192.168.25.231

In Kibana, select Management -> Kibana -> Data Views -> cowrie*<br>
Edit TTYLog<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/88efde75-cfe5-4e2f-83c8-b12bf74d237a)

Change the IP in the URL Template to match your IP or you hostname if it resolves in the network and save the update<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/322731e1-0b0a-4211-8af1-22678da6bef4)


This is an example of the output:

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/2991bff6-bbd9-4968-9642-1d8b7c78c360)

