# Updating Dashboard Mapping

Management → Kibana → Saved → Objects

If any component of docker get updated, Kibana is likely to re-add all the dashboard. It is important to delete all the current objects by searching in the search bar: cowrie dshield.<br>
Select and delete all objects like the picture below (list might be slighly different than below)<br>
 
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/409ba24c-8c41-4603-b40d-e499501f3551)

## Import the Updated Dashboards
The current or updated dashboard can be downloaded from Github using curl (Windows & Linux) as follow:<br>

curl -LJO https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/dshield_sensor_8.13.0.ndjson

From the same Location Saved → Objects, select **Import**  to import the updated JSON dashboard file into Elasticsearch<br>

## After you Imported the Updated Dashboard

The result will look like this after the JSON has been re-imported (11 Titles):
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/eee5ba35-ece9-45a3-8840-9e70cfcf7609)
 
cowrie* has been added as part of the Elasticsearch indices which is used by the Security App. By adding cowrie*, it is now used by the Security → Rules to track threat intelligence matches by the SIEM part of Elastic. The minimum of 4 rules that are needed will also be listed in Management → Alerts and Insights → Rules
 ![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/ab1b4a78-bb6d-4630-9ff5-8b3eea437c02)

## Update cowrie Right-Click Objects

After importing the updated dashboards, it is necessary to edit the cowrie mapping to change the default IP in some of the custom fields to work.<br>
The IP address must be change from 192.168.25.231 to the ELK server IP address. To make the change, goto Management -> Kibana -> Data Views and select cowrie*<br>

**Note**: If you get some errors after importing an updated dashboard, you may have to select **edit** in cowrie* and select **Save** to update the list of objects in the template.<br>
Now edit each of the Name listed below to change the IP address to match your ELK name or IP<br>
- Edit Arkime, Context3Hash, Context3IP and TTYLog <br>

 ![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/1b9f9980-790c-4882-8844-32005c752eed)
 
 # Security -> Alerts
 
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/0bbf9d7a-3981-4690-a327-c1c69e6a0723)

