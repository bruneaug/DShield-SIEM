 # Troubleshooting DShield Sensor

https://github.com/DShield-ISC/dshield/blob/main/STATUSERRORS.md<br>
https://github.com/DShield-ISC/dshield/blob/main/docs/general-guides/Troubleshooting.md<br>

## Reset & Reinstall

$ sudo ./bin/quickreset.sh<br>
$ sudo ./bin/install.sh<br>

## Connecting to ISC
Testing connection to ISC website<br>
curl -s 'https://isc.sans.edu/api/portcheck?json'<br>

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


## Troubleshooting DShield Agent

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
<pre></pre>
guy@dshieldhp1:~/dshield$ sudo lsof -i -P -n | grep LISTEN
systemd       1            root  209u  IPv6   7839      0t0  TCP *:12222 (LISTEN)
systemd-r   553 systemd-resolve   15u  IPv4   7685      0t0  TCP 127.0.0.53:53 (LISTEN)
systemd-r   553 systemd-resolve   17u  IPv4   7687      0t0  TCP 127.0.0.54:53 (LISTEN)
sshd       3645            root    3u  IPv6   7839      0t0  TCP *:12222 (LISTEN)
master    14777            root   13u  IPv4  51880      0t0  TCP *:25 (LISTEN)
master    14777            root   14u  IPv6  51881      0t0  TCP *:25 (LISTEN)
python3   14858            root    9u  IPv4  52169      0t0  TCP *:8000 (LISTEN)
python3   14858            root   10u  IPv4  52170      0t0  TCP *:8443 (LISTEN)
twistd    15068          cowrie   11u  IPv4  53444      0t0  TCP *:2222 (LISTEN)
twistd    15068          cowrie   12u  IPv4  53445      0t0  TCP *:2223 (LISTEN)
</pre>

## Logs Location

/var/log/dshield.log -> firewall<br>
/srv/db -> webhoneypot-*.json<br>
/srv/cowrie/var/lib/cowrie/downloads<br>
/srv/cowrie/var/log/cowrie/ -> Logs<br>
/srv/cowrie/var/lib/cowrie/tty -> tty logs (if you have enabled them)<br>

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

# DShield SIEM Setup

The example to setup a docker partition is for 300GB but it can be more if you wish:<br>
https://github.com/bruneaug/DShield-SIEM/tree/main<br>

Picture showing 2 partitions

## DShield SIEM main page is missing some data

Check the folowing tables to make sure they are correctly loaded<br>

Picture here of index example

Go to Management -> Data -> Index Management<br>
Type cowrie in the search box<br>
Do they all look like this with the date?<br>

Put picture here

You likely need to do this to refresh the index:<br>
In the Kibana console<br>
Go to Management -> Kibana -> Data Views -> select cowrie*<br>
Select Edit in the Right corner<br>
Select Save to refresh the index<br>
