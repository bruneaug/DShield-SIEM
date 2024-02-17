#!/usr/bin/bash

# Guy Bruneau
# Date: 17 Feb 2024
# Version: 1.0

# Daemonlogger saves the files in this format: daemonlogger.pcap.1707945546
# For Arkime to process the files it needs to end with .pcap
# daemonlogger_1707945546.pcap

for f in daemonlogger*; do

  mv -- "$f" "`echo $f | sed "s/\(.*\)\.\(.*\)\.\(.*\)/\1_\3.\2/g"`";

done
