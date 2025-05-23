# Configuration of VWware Workstation with NAT
If you plan to use VMware workstation using NAT on a laptop, this is how NAT should be configured in order for the DShield Sensor to be able to send its logs to ELK.<br>

- As Administrator<br>
- cd C:\Program Files (x86)\VMware\VMware Workstation<br>
- Execute **vmnetcfg.exe**<br>
- Select NAT interface -> NAT Settings
- You need to add to following information for ELK to be reachable via SSH, logstash & Kibana
- Using the NAT IP of the ELK server, configure NAT as per this example:

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/5f8d7452-d77b-4f07-b2af-fa7b0f2482aa)

Add the following ports:
* 22 Access to SSH
* 5044 Access to Logstash
* 5601 Access to Kibana
* 8220 Access to Fleet Server

- Now ELK can be reached via the 3 main ports remotely, including filebeat from the DShield sensor(s).<br>
## Configure Windows Firewall
In order for the DShield sensor to connect to ELK via NAT, you are required to add a firewall rule to the Windows firewall.<br>
I most cases, a rule that allow everything TCP and under the Advanced tab only Private and Public are selected and Block edge traversal<br>
should work<br>.
![ElasticKibana](https://github.com/user-attachments/assets/0fb009ff-5728-4b48-80d9-fecda1b6c491)

### Filebeat -> Logstash
The IP to use from filebeat to connect to ELK is the actual IP for the host not the NAT IP<br>
If the host IP is 192.168.25.5 and the NAT is 192.168.175.35, filebeat IP is going to be **192.168.25.5** to connect to logstash.<br>

### Cloud Sensor Setup - Filebeat -> Home Router -> Logstash
To connect from a cloud sensor to your local ELK Stack, you need to do the following:
- Configure the home router to NAT to your ELK Stack local IP address<br>
- Use the router IP address (I would recommend adding a hostname to your home IP in case it changes) from your sensor to connect to your home router<br>
- Final connection should look like this: sensor -> NAT Router IP -> ELK Stack

### Troubleshooting Remote Access to 5044
If unable to connect via filebeat test, check to see if Windows Defender is blocking access to the VM.<br>
Disable the firewall and re-run the filebeat test to see if it still fails. If it fails, there might be an <br>
issue with the **NAT** configuration.

### Access ELK via the Laptop IP
Access Kibana: https://ELK:5601
