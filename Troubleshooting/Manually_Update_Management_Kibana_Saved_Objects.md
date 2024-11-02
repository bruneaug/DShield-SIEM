# Updating Dashboard Mapping

The best place to start to udate the dashboard, start by doing a normal update with **git pull** and follow these steps in the Gitub Update:<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/docker_useful_commands..md#download-github-update****

Management → Kibana → Saved → Objects

If any component of docker get updated, Kibana is likely to re-add all the dashboard. It is important to delete all the current objects by searching in the search bar: **cowrie dshield**.<br>
Select and delete all objects like the picture below (list might be slighly different than below)<br>
 
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/476e03cd-88ae-40b5-a7ad-6ad7757a6bf2)

## Import the Updated Dashboards

The current or updated dashboard can be downloaded from Github using curl in Windows Download directory and wget in Linux as follow:<br>

Windows: curl -LJO https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/dshield_sensor_8.15.0.ndjson<br>
Linux: wget https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/dshield_sensor_8.15.0.ndjson<br>

From the same Location: Saved → Objects<br>
Select **Import**  to import the updated JSON dashboard file into Elasticsearch<br>

## After you Imported the Updated Dashboard

The result will look like this after the JSON has been re-imported (23 Titles):
![image](https://github.com/user-attachments/assets/6f0ba3fc-900b-407e-a16a-a9e0009819a6)
 
## Update cowrie Right-Click Objects

**Important Note**: This step is only done if any of the following services have been added to your own ELK stack -> Arkime and TTYLog. Otherwise, skip this<br>

After importing the updated dashboards, if you have installed Arkime, Context3Hash, Context3IP and TTYLog (those are additional tools if you wish to use them), you need to change the default of my test ELK system to your own ELK server for the right-click functions to work.<br>

The IP address that you need to change is 192.168.25.231 to your own ELK server IP address.<br>
To make the change, goto Management -> Kibana -> Data Views and select cowrie*<br>

**Note**: If you get some errors after importing an updated dashboard, you may have to select **edit** in cowrie* and select **Save** to update the list of objects in the template.<br>

Now edit any of the following services **if you are using Arkime and TTYLog** and change the IP address to match your ELK servername or IP<br>

![image](https://github.com/user-attachments/assets/63385cbf-6f64-4291-ad4c-0bddaf139f7b)

- Select the pen on the right to Edit, make the change and save<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/f32c4cdd-301c-4b05-a8f1-30a81cb72901)

## After the update, access the dashboard:<br>
 **DShield Main Page Activity**
