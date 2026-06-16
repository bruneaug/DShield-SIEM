# Updating Dashboard Mapping

The best place to start to udate the dashboard, start by doing a normal update with **git pull** and follow these steps in the Gitub Update:<br>
https://github.com/bruneaug/DShield-SIEM/blob/main/Troubleshooting/docker_useful_commands..md#download-github-update****

Management → Kibana → Saved → Objects

If any component of docker get updated, Kibana is likely to re-add all the dashboard. It is important to delete all the current objects by searching in the search bar: **cowrie dshield zeek**.<br>
Select and delete all objects like the picture below (list might be slighly different than below)<br>
 
![image](https://github.com/user-attachments/assets/cc5f4447-702e-4641-b786-09d820fe443a)

## Import the Updated Dashboards

The current or updated dashboard can be downloaded from Github using curl in Windows Download directory and wget in Linux as follow:<br>
**Note**: It is important that the downloaded file is a ndjson. Using a browser will case the file to download incorrectly.<br>

Windows: 
```
wget https://raw.githubusercontent.com/bruneaug/DShield-SIEM/refs/heads/main/scripts/dshield_sensor_8.19.15.ndjson
```
Linux: 
```
wget https://raw.githubusercontent.com/bruneaug/DShield-SIEM/refs/heads/main/scripts/dshield_sensor_8.19.7.ndjson
```
From the same Location: Saved → Objects<br>
Select **Import**  to import the updated JSON dashboard file into Elasticsearch<br>

## After you Imported the Updated Dashboard

The result will look like this after the JSON has been re-imported (24 Titles):
<img width="658" height="832" alt="image" src="https://github.com/user-attachments/assets/08a2ea77-bd82-4fc9-bf9d-bd573b62950c" />


