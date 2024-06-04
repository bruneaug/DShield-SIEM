# Configuration of VWware Workstation with NAT
If you plan to use VMware workstation using NAT on a laptop, this is how NAT should be configured in order for the DShield Sensor to be able to send its logs to ELK.<br>

- As Administrator<br>
- cd C:\Program Files (x86)\VMware\VMware Workstation<br>
- Execute **vmnetcfg.exe**<br>
- Select NAT interface -> NAT Settings
- You need to add to following information for ELK to be reachable via SSH, logstash & Kibana
- Using the NAT IP of the ELK server, configure NAT as per this example:

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/5f8d7452-d77b-4f07-b2af-fa7b0f2482aa)

- Now ELK can be reached via the 3 main ports remotely, including filebeat from the DShield sensor(s).
