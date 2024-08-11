 # Troubleshooting DShield Sensor

https://github.com/DShield-ISC/dshield/blob/main/STATUSERRORS.md<br>
https://github.com/DShield-ISC/dshield/blob/main/docs/general-guides/Troubleshooting.md<br>

## DShield Sensor Setup
The sensor only support 64-Bit OS on the PI and any combination of VM or hardware sensor<br>

## Review Error Logs
After the installation or upgrade, you can review the errors during the installation<br>
sudo cat /srv/log/isc-agent.err

## Reset & Reinstall
This command is used to reset the DShield sensor and remove everything.<br>

$ sudo ./bin/quickreset.sh<br>
$ sudo ./bin/install.sh<br>

## Testing Connection to ISC
Testing connection to ISC website<br>
curl -s 'https://isc.sans.edu/api/portcheck?json'<br>

## Testing iptables Logs

$ sudo /srv/dshield/fwlogparser.py

## Cannot Login to DShield Sensor

$ ps -aef | grep 12222<br>

If TCP/12222 isn't listening to run the following commands:<br>

$ sudo systemctl status ssh<br>

If not listening<br>

$ sudo systemctl start ssh<br>
$ sudo systemctl status ssh<br>
$ sudo systemctl enable ssh<br>

## sudo to cowrie

sudo su cowrie -<br>

## Editing the Cowrie Configuration File
This is the location for the DShield sensor configuration.<br>
$ sudo vi /etc/dshield.ini<br>

## Troubleshooting DShield isc-agent

Sometimes thew isc-agent has errors such as this picture:<br>

![isc_agent_error](https://github.com/user-attachments/assets/b9c3e43b-4de5-444d-960a-7e1c84634362)

If _/var/log/dshield.log_ is missing do the following to create an empty file:<br>
$ sudo touch /var/log/dshield.log<br>
$ sudo chown  syslog:adm /var/log/dshield.log<br>

Can you run the following commands:<br>

$ sudo systemctl status isc-agent<br>

If it isn't running, try to start it after with this:<br>

$ sudo systemctl start isc-agent<br>
$ sudo systemctl restart isc-agent<br>
$ sudo systemctl status isc-agent<br>
$ sudo systemctl enable isc-agent<br>


## PI Won't start IPTables & isc-agent

Add root cronjob to delay start if part to the PI won't start the isc-agent:<br>

@reboot sleep 60 && systemctl start isc-agent<br>

## Sensor Status and Listening Ports

$ sudo /srv/dshield/status.sh<br>
$ sudo lsof -i -P -n | grep LISTEN<br>
<pre>
guy@collector:~$ sudo lsof -i -P -n | grep LISTEN
systemd      1            root  233u  IPv6   7564      0t0  TCP *:12222 (LISTEN)
systemd-r  556 systemd-resolve   15u  IPv4   8331      0t0  TCP 127.0.0.53:53 (LISTEN)
systemd-r  556 systemd-resolve   17u  IPv4   8333      0t0  TCP 127.0.0.54:53 (LISTEN)
python3    962            root    9u  IPv4  10880      0t0  TCP *:8000 (LISTEN)
python3    962            root   10u  IPv4  10881      0t0  TCP *:8443 (LISTEN)
master    1355            root   13u  IPv4  11561      0t0  TCP *:25 (LISTEN)
sshd      1386            root    3u  IPv6   7564      0t0  TCP *:12222 (LISTEN)
twistd    3050          cowrie   11u  IPv4  22593      0t0  TCP *:2222 (LISTEN)
twistd    3050          cowrie   12u  IPv4  22594      0t0  TCP *:2223 (LISTEN)
</pre>

## Logs Location
Enable TTYLog by editing this file. It is important to remember when you  the DShield sensor this will reset to false.<br>
Look for: ttylog = false to ttylog = true<br>
$ sudo vi /srv/cowrie/cowrie.cfg 

/var/log/dshield.log -> firewall<br>
/srv/db -> webhoneypot-*.json<br>
/srv/cowrie/var/lib/cowrie/downloads<br>
/srv/cowrie/var/log/cowrie/ -> Logs<br>
/srv/cowrie/var/lib/cowrie/tty -> tty logs (if you have enabled them)<br>

## Router Port Forwarding or DMZ
The easiest way of getting your DShield sensor expose it to add it to the **DMZ** of your router.<br>
This is an example of custom router port forwarding to the DShield sensor.<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/DShield_Sensor_Port_Forwardng_Example.PNG

## Disable WIFI
This command should disable WIFI on the PI<br>
$ sudo nmcli radio wifi off<br>

## Config file
This is the DShield sensor configuration file<br>
sudo vi /etc/dshield.ini<br>

## Remote Sensor Login

SSH is refused by the sensor<br>

Login the sensor and watch the syslog with trying to remotely login<br>
Do you have a public key in the sensor from a specific host (must used the same host that key came from)<br>
If you do, try removing the public key and try to login again<br>

$ sudo grep your_account /var/log/syslog<br>

## IPTables Issues
These steps is for troubleshooting Ubuntu OS. The iptables firewall is located:<br>
$ sudo cat /etc/network/iptables

Firewall won't start:<br>
Lookin for any forms of errors in syslog that might indicate why it isn't starting.<br>
$ sudo grep -i error /var/log/syslog | grep iptables

Normal output of firewall when checking the status:<br>
$ sudo systemctl status dshieldfw
<pre>
dshieldfw.service - DShield Firewall Configuration
  Loaded: loaded (/etc/systemd/system/dshieldfw.service; enabled; preset: enabled)
  Active: inactive (dead) since Fri 2024-08-09 16:58:28 UTC; 3h 53min ago
Duration: 1.616s
    Docs: https://isc.sans.edu
Main PID: 642 (code=exited, status=0/SUCCESS)
     CPU: 19ms

Aug 09 16:58:26 collector systemd[1]: Started dshieldfw.service - DShield Firewall Configuration.
Aug 09 16:58:28 collector systemd[1]: dshieldfw.service: Deactivated successfully.
****
</pre>
$ sudo systemctl restart dshieldfw<br>
$ sudo systemctl status dshieldfw<br

##  the DShield Sensor

$ cd dshield<br>
$ sudo git pull<br>
$ sudo bin/install.sh --update<br>
$ sudo reboot<br>

## OS Update

$ sudo apt-get update<br>
$ sudo apt-get upgrade
$ sudo reboot<br>

## Sensor Log Backup
You are encourage to setup some kind of backup for your logs since the sensor is setup by defaul to keep the cowrie logs for 8 days and the iptables only daily.<br>
These scripts can be used to backup you logs nightly<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/AddOn/Backup_DShield_Sensor_Logs.md
Jesse's example of data backup<br>
https://isc.sans.edu/diary/DShield+Honeypot+Maintenance+and+Data+Retention/30024

## Checking Cowrie Logs in ISC
Access your logs at this location on the ISC website. The 3 highlighted are the logs populating your data in your account.<br>
![image](https://github.com/user-attachments/assets/e8a10de8-49c9-4f6f-bd5a-ddd2bc34f547)


# Troubleshooting DShield SIEM

## Installing DShield SIEM on P5
https://github.com/amelete11235/homelab/blob/main/Installing%20DShield%20SIEM%20on%20a%20Raspberry%20Pi%205%20-%208%20GB%20RAM/Installing%20DShield%20SIEM%20on%20a%20Raspberry%20Pi%205%20-%208%20GB%20RAM.md

## DShield SIEM main page is missing some data
If the main interface is only showing some logs and not all of them like the example below, check the tables next to make sure if have been loaded correcly.<br>
This picture shows only the iptables logs. Something isn't configured correctly.

![DShield_Interface_Missing_logs](https://github.com/user-attachments/assets/09832dd1-7fff-45ba-b10e-3c0b7eb2b298)

Check the folowing tables to make sure they are correctly loaded with the date as an extension?<br>
Go to Management -> Data -> Index Management<br>
Type **cowrie** in the search box<br>
Do they all look like this with the date? You can also see there is data in the indices<br>

![image](https://github.com/user-attachments/assets/623df8e9-ceb0-4a44-b635-16dc91aef143)

If there is data in the indice, you need to refresh the cowrie* data table to force a reload<br>
You need to do this step to refresh the index:<br>
In the Kibana console<br>
Go to Management -> Kibana -> Data Views -> select cowrie*<br>
Select **Edit** in the upper Right corner<br>
Select **Save** to refresh the index<br>
Note: Sometimes you might get an error and you have to click **Save** twice to save the changes.

# Docker Troubleshooting Commands
This is a list of command that can be useful to troubleshoot issues with the docker.<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/docker_useful_commands..md

# Linux Commands

SANS Linux Essential Cheet Sheet https://sansorg.egnyte.com/dl/T2c7pGW9p0

Official JQ site: https://jqlang.github.io/jq/download/

JQ paper for parsing various cowrie logs by Kaela Reed<br>
https://isc.sans.edu/diary/The+Art+of+JQ+and+Commandline+Fu+Guest+Diary/31006

Paper for corralation DShield Sensor data by Joshua Jobe<br>
https://isc.sans.edu/diary/Is+that+It+Finding+the+Unknown+Correlations+Between+Honeypot+Logs+PCAPs+Guest+Diary/30962

Parsing cowrie logs with Python by Josh Jobe<br>
https://github.com/jrjobe/DShield-Cowrie-json-Parser

## Various Linux Commands
$ sudo last                             -> shows who was login the beside your account<br>
$ netstat -an | grep 5044               -> Check if the port is active and connected to an IP<br>
$ w                                     -> Shows who else is login<br>
$ uptime                                -> Shows how long the server has been running without a reboot<br>
$ crontab -l                            -> List all the active cronjobs<br>
$ netstat -an | grep '5601\\|9200\\|5044'  -> Shows if Elasticsearch and logstash are listening<br>


