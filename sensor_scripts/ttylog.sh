#!/usr/bin/bash

# Guy Bruneau, guybruneau@outlook.com
# Date: 11 Jan 2024
# Version: 0.5
# Date: 5 Feb 2024
# Version: 1.1
# Fixed date for log parsing

# This script is used to parse the TTY logs captured by the DShield Sensor.

# List the files by day save in the /srv/cowrie/var/lib/cowrie/tty directory.

# Change directory
cd ~/scripts

TODAY=$(date "+%b %e")
YESTERDAY=$(date -d "1 hour ago" '+%Y-%m-%d')
DIRECTORY="$HOME/ttylog"
TTYDIR="/srv/cowrie/var/lib/cowrie/tty/"

# Check if directory exist and create it if doesn't
if [ ! -d "$DIRECTORY" ]; then
   mkdir -p "$DIRECTORY"
fi

# Get a copy of playlog localy

playlog="/srv/cowrie/bin/playlog"

if [ ! -f "playlog" ]; then

  # Make a copy of the playlog script to the script
  # directory
  /usr/bin/cp /srv/cowrie/bin/playlog ~/scripts

  # rename python to python3
  sed -i 's/python/python3/g' ~/scripts/playlog

fi

array=`/usr/bin/ls -l /srv/cowrie/var/lib/cowrie/tty | grep "$TODAY" | awk '{ print "~/scripts/playlog -b /srv/cowrie/var/lib/cowrie/tty/"$9" | txt2html >&1 --outfile ../ttylog/"$9".html" }'`
filelist=`/usr/bin/ls -l /srv/cowrie/var/lib/cowrie/tty | grep "$TODAY" | awk '{ print $9 }'`

   echo "${array[@]}" > test.txt
   chmod 755 test.txt
   exec ./test.txt

