# Arkime Cont3xt

"**Cont3xt centralizes and simplifies a structured approach to gathering contextual intelligence in support of technical investigations.**"[1]<br>
Login the ELK server to enable Cont3xt to gather threat intelligence from multiple locations.<br>

$ sudo /opt/arkime/bin/Configure --cont3xt

Edit /opt/arkime/etc/cont3xt.ini and update elasticsearch setting<br>
$ sudo vi /opt/arkime/etc/cont3xt.ini

**Important**: passwordSecret must match the same passwordSecret that was added to /opt/arkime/etc/config.ini<br>
Edit config.ini and copy the _paswordSecret_<br>

$ sudo vi /opt/arkime/etc/config.ini

Now edit the cont3xt.ini and set the 2 required fields<br>
$ sudo vi /opt/arkime/etc/cont3xt.ini

elasticsearch=https://elastic:student@es01:9200
passwordSecret=student

Next we need to add --insecure to the service to start correctly<br>
$ sudo vi /etc/systemd/system/arkimecont3xt.service

ExecStart=/bin/sh -c '/opt/arkime/bin/node cont3xt.js --insecure -c /opt/arkime/etc/cont3xt.ini ${OPTIONS} >> /opt/arkime/logs/cont3xt.log 2>&1'

$ sudo systemctl daemon-reload<br>
$ sudo systemctl start arkimecont3xt<br>
$ sudo systemctl status arkimecont3xt<br>
$ sudo systemctl enable arkimecont3xt<br>
Check to see if the services is started listening on TCP 3218
$ netstat -an | grep 3218<br>

Login in the service using the same username/password set for Arkime<br>
http://IP:3218


[1] https://arkime.com/cont3xt
