Here is a script I use every time I log into my honeypots. The script lists all the directories for the 'sources of logs' outlined in the BACS4499 Attack Observation Basics. It quickly shows me the new log files. I call the script 'log-dirs.sh. If you find value with it, use it.
-----------------------------------
#!/bin/sh
###################################################
#  log-dirs.sh   Version 1 - Nov 5, 2024           #
# This script displays the Log Source directories #
# By Al Foy - SANS BACS 4499 Internship           #
###################################################
# Directory lists
echo "\nDirectory of Log Sources, sorted by date & time - newest to oldest"
echo "  If output is longer than one page:"
echo "   <space> to forward one page or <Enter> for one row at a time \n"
echo "  Log Type                                 Location"
echo "-------------------------------------    ----------------------------------------"
echo " Web Logs                                 /srv/db/"
echo " SSH / telnet logs                        /srv/cowrie/var/log/cowrie/"
echo " SSH / telnet tty files                   /srv/cowrie/var/lib/cowrie/tty/"
echo " Firewall logs                            /var/log/"
echo " Honeypot downloads/uploads (malware)     /srv/cowrie/var/lib/cowrie/downloads"
echo "-------------------------------------    ----------------------------------------\n"
sleep 3s
# Lists the Web Logs from /srv/db/; inserts a seperator; waits 5 seconds
echo "Web Logs from /srv/db/"
ls -l --sort=time /srv/db/ | more
echo "\n===================================\n"
sleep 5s
# Lists the Firewall Logs from /var/log/; inserts a seperator; waits 5 seconds
echo "Firewall Logs from /var/log/"
ls -l --sort=time /var/log/ | more
echo "\n===================================\n"
sleep 5s
# Lists the Honeypot down/uploads = malware from /srv/cowrie/var/lib/cowrie/downloads; inserts a seperator; waits 5 seconds
echo "Honeypot down/uploads = malware from /srv/cowrie/var/lib/cowrie/downloads"
ls -l --sort=time /srv/cowrie/var/lib/cowrie/downloads | more
echo "\n===================================\n"
sleep 5s
# Lists the SSH / telnet Logs from /srv/cowrie/var/log/cowrie/; inserts a seperator; waits 5 seconds
echo "SSH / telnet Logs from /srv/cowrie/var/log/cowrie/"
ls -l --sort=time /srv/cowrie/var/log/cowrie/ | more
echo "\n===================================\n"
sleep 5s
# Lists the SSH / telnet filess from /srv/cowrie/var/log/cowrie/
echo "SSH / telnet tty files from /srv/cowrie/var/lib/cowrie/tty/"
ls -l --sort=time /srv/cowrie/var/lib/cowrie/tty/ | more
