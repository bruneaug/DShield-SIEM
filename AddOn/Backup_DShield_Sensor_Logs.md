# Backup DShield Sensor Logs

First step is to download all the files to your sensor if that wasn't previously done.<br>
Go to this site and follow the inststruction to pull the packages:<br>
https://github.com/bruneaug/DShield-Sensor/tree/main

After a copy of the scripts have been downloaded to the sensor local script directory, setup a cronjob (rename guy to your location) as root and add the following:
````
sudo crontab -e
````
\# Copy the daily iptables logs at the end of the day<br>
58 23 * * * /home/guy/scripts/copy_iptables.sh > /dev/null 2>1&<br>
\# <br>
\#  Copy the daily cowrie, download & webhoneypot logs at the end of the day<br>
0 2 * * * /home/guy/scripts/copy_cowrie.sh > /dev/null 2>1& > /dev/null 2>1&<br>

## Backup Locations

If the backup directories don't exists, the script will automatically create all 3 of them when the script runs.

The copy_iptables.sh script will make a backup copy of iptables at:<br>
/srv/NSM/iptables

The copy_cowrie.sh script will make a backup copy of iptables at:<br>
/srv/NSM/cowrie
/srv/NSM/webhoneypot
/srv/NSM/downloads

**Note**: When the sensor update the cowrie software or you manually run the update, _the logs usually get erased_.
