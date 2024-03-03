$ sudo /opt/arkime/bin/Configure --cont3xt
Edit /opt/arkime/etc/cont3xt.ini and update elasticsearch setting
$ sudo vi /opt/arkime/etc/cont3xt.ini

passwordSecret must match the same passwordSecret that was added to /opt/arkime/etc/config.ini

elasticsearch=https://elastic:student@es01:9200
passwordSecret=student

$ sudo vi /etc/systemd/system/arkimecont3xt.service

ExecStart=/bin/sh -c '/opt/arkime/bin/node cont3xt.js --insecure -c /opt/arkime/etc/cont3xt.ini ${OPTIONS} >> /opt/arkime/logs/cont3xt.log 2>&1'

$ sudo systemctl daemon-reload
$ sudo systemctl start arkimecont3xt
$ sudo systemctl status arkimecont3xt
$ sudo systemctl enable arkimecont3xt
$ netstat -an | grep 3218

http://IP:3218

http://192.168.25.231:3218?q=${indicator}

You'll need to run cont3xt.js from the cont3xt directory.
If Cont3xt isn't working, look at /opt/arkime/log/cont3xt.log

$ sudo cp /opt/arkime/etc/parliament.ini.sample /opt/arkime/etc/parliament.ini
$ sudo vi /opt/arkime/etc/parliament.ini

port=8008
usersElasticsearch=https://elastic:student@es01:9200

$ sudo vi /etc/systemd/system/arkimeparliament.service
vi ExecStart=/bin/sh -c '/opt/arkime/bin/node parliament.js --insecure -c /opt/arkime/etc/parliament.ini ${OPTIONS} >> /opt/arkime/logs/parliament.log 2>&1'


$ sudo systemctl daemon-reload
$ sudo /opt/arkime/bin/Configure --parliament
$ sudo systemctl start arkimeparliament
$ sudo systemctl status arkimeparliament
$ netstat -an | grep 8008

$ sudo tail -f /opt/arkime/logs/parliament.log


sudo /opt/arkime/db/db.pl --esuser elastic:student --insecure https://es01:9200 backup arkime

$ sudo systemctl stop arkimecapture.service
$ sudo systemctl stop arkimeviewer.service
$ sudo systemctl stop arkimecont3xt

sudo /opt/arkime/bin/arkime_add_user.sh --insecure admin "Admin User" training --admin
 sudo /opt/arkime/bin/arkime_add_user.sh --insecure digest "Arkime User" ARKIME_PASSWORD --admin

