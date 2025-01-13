# Installing Zeek on DShield Sensor

This is an addon to the DShield sensor if you have to space to log the data. Zeek is installed in the **/opt/zeek** directory.<br>

## Adding Zeek to DShield Sensor Agent Policy

If you haven't already added Zeek with your DShield sensor elastic-agent, goto:<br>
Management -> Fleet -> Agent policies<br>

* My policy is DShield Sensors:<br>
* Select Integration and zeek to add it to the sensor<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/34c22e6c-ea2b-4e50-8b4c-fde0745dc9ed)

Now proceed with the sensor Zeek installation using the following steps.<br>
Reference: https://docs.zeek.org/en/master/install.html#binary-packages
## Installing for Ubuntu 20.04
````
echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
 sudo apt update
 sudo apt upgrade
 sudo apt install zeek-7.0
````
## Installing for Ubuntu 24.04
````
echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_24.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_24.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
sudo apt update
sudo apt install zeek-7.0
````

## Configuring and Starting Zeek

Reference: https://docs.zeek.org/en/master/quickstart.html#managing-zeek-with-zeekcontrol

Confirm the interface (default interface eth0)<br>
sudo vi /opt/zeek/etc/node.cfg<br>

Confirm "home" network(s)<br>

$ sudo vi /opt/zeek/etc/networks.cfg<br>
192.168.25.0/24<br>

Add to local.zeek JSON log formatting<br>

$ sudo vi /opt/zeek/share/zeek/site/local.zeek<br>

@load policy/tuning/json-logs.zeek<br>

 Now start the ZeekControl shell like:<br>

$ sudo /opt/zeek/bin/zeekctl<br>

Since this is the first-time use of the shell, perform an initial installation of the ZeekControl configuration:<br>

[ZeekControl] > install<br>

Then start up a Zeek instance:<br>

[ZeekControl] > start<br>

There is another ZeekControl command, deploy, that combines the above two steps and can be run after any changes to Zeek policy scripts or the ZeekControl configuration. Note that the check command is available to validate a modified configuration before installing it.<br>

[ZeekControl] > deploy<br>
[ZeekControl] > exit<br>

### Lets create a soft link to /usr/local/bin<br>

$ sudo ln -s /opt/zeek/bin/zeekctl /usr/local/bin/zeekctl<br>
<pre>
guy@switchone:~$ sudo zeekctl status<br>
Name         Type       Host          Status    Pid    Started<br>
zeek         standalone localhost     running   17384  22 Mar 16:44:04<br>
</pre>

### Additional Commands

$ sudo zeekctl stop<br>
$ sudo zeekctl start<br>
$ sudo zeekctl restart<br>

# Dashboard Logs Zeek Overview

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/0aac6ec0-43cd-48ae-be56-991c215613ef)
