# Updating Dashboard Mapping

Management → Kibana → Saved → Object

If any component of docker get updated, Kibana re-add all the dashboard. It is important to delete them by searching in the search bar: cowrie dshield.
Select and delete them all and download the current map and manually upload it in this same location. Go to this directory: https://github.com/bruneaug/DShield-SIEM/tree/main/scripts 
The file to download is: _dshield_sensor_8.11.1.ndjson_

## Before you Delete
 
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/409ba24c-8c41-4603-b40d-e499501f3551)

## After you Imported the Updated Dashboard

The result will look like this after the JSON has been re-imported (6 Titles):
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/d5e6a2ce-fa8e-41bc-af2f-28079ee11054)
 
cowrie* has been added as part of the Elasticsearch indices which is used by the Security App. By adding cowrie*, it is now used by the Security → Rules to track threat intelligence matches by the SIEM part of Elastic. The minimum of 4 rules that are needed will also be listed in Management → Alerts and Insights → Rules
 ![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/ab1b4a78-bb6d-4630-9ff5-8b3eea437c02)

## Update cowrie Right-Click Objects

After importing the updated dashboards, it is necessary to edit the cowrie mapping to change the default IP in some of the custom fields to work. The IP address must be change from 192.168.25.231 to the ELK server IP address. To make the change, goto Management -> Kibana -> Data Views and select cowrie*<br>
- Edit Arkime, Context3Hash, Context3IP and TTYLog to change the default IP address and save the changes.<br>

 ![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/1b9f9980-790c-4882-8844-32005c752eed)
 
 # Security -> Alerts
 
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/0bbf9d7a-3981-4690-a327-c1c69e6a0723)

