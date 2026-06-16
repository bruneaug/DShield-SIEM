# TTY Logs Viewed in DShield SIEM
The first step to be able to parse and send a copy of the TTY logs to DShield SIEM is to get the script<br>
Goto [DShield Sensor Git](https://github.com/bruneaug/DShield-Sensor) and get the scripts if not already done<br>
The script used to parse the TTY logs daily is: daily_tty.sh<br>
### Activate The TTY Log Parsing
Edit the crontab to add the following configuration which will run daily<br>
```
sudo crontab -e
```
# Convert to base64 TTY logs
58 23 * * * /home/guy/scripts/daily_tty.sh > /dev/null 2>1&

This scipt will save a file in this directory on the sensor which will be parse by fileabeat<br>
```
sudo ls -l /srv/ttylog/*
```
Resulting in the following log:<br>
<img width="486" height="28" alt="image" src="https://github.com/user-attachments/assets/8f220ff2-168d-4b77-8fa0-4c28b30d4172" />

# DShield SIEM Logs
The ELK stack will automatically decode the base64 logs and present the results by selecting the TTY log hash related to the activity<br>
Selecting **DShield - Traffic Analytic** and the TTY Log Hash, you are presented with the list of hashes related to the actor/bot<br>
activity. 
<img width="1557" height="735" alt="image" src="https://github.com/user-attachments/assets/ff5b0136-13be-45d8-a7c3-e0469d0a13d6" />
