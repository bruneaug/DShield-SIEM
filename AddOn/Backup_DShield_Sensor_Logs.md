# Backup DShield Sensor Logs
These 2 script are used to make backup of the the daily logs. This includes iptables, cowrie & webhoneypot.

$ cd ~/scripts<br>
$ curl https://raw.githubusercontent.com/bruneaug/DShield-SIEM/main/sensor_scripts/copy_cowrie.sh -o copy_cowrie.sh<br>
$ curl https://raw.githubusercontent.com/bruneaug/DShield-SIEM/main/sensor_scripts/copy_iptables.sh -o copy_iptables.sh<br>
$ chmod 755 *.sh

After a copy of the scripts have been downloaded to the sensor local script directory, setup a cronjob (rename guy to your location) as root and add the following:

$ sudo crontab -e

\# Copy the daily iptables logs at the end of the day<br>
58 23 * * * /home/guy/scripts/copy_iptables.sh > /dev/null 2>1&<br>
\# <br>
\#  Copy the daily cowrie & webhoneypot logs at the end of the day<br>
0 2 * * * /home/guy/scripts/copy_cowrie.sh > /dev/null 2>1& > /dev/null 2>1&<br>

The copy_iptables.sh script will make a backup copy of iptables at:<br>
/srv/NSM/iptables

The copy_cowrie.sh script will make a backup copy of iptables at:<br>
/srv/NSM/cowrie
/srv/NSM/webhoneypot

When the sensor update the cowrie software or you manually run the update, the logs usually get erased.
