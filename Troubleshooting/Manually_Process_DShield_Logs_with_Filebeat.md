# Reprocessing DShield Logs with Filebeat to DShield SIEM
In order to manually seed the DShield sensor logs to the DShield SIEM, you will need the following:<br>
- Ubuntu 24.04
- Filebeat version that match DShield SIEM
- Download the DShield sensor GitHub package

You can probably install Filebeat directly on the same server DShhield SIEM is running and reprocess the logs from <br>
the same device.<br>
- Install [filebeat](https://github.com/bruneaug/DShield-SIEM/blob/main/README.md#install-the-version-matching-your-architecture) the version matching current DSield SIEM
- Download the GitHub package for the [sensor](https://github.com/bruneaug/DShield-Sensor) by following the instructions on that page
- Copy the logs to the server in a directory of your choice (i.e. opt/cowrie) with a separate directory for each logs
- Update [filebeat.yml](https://github.com/bruneaug/DShield-Sensor/blob/main/filebeat/filebeat.yml) to reflect the new log location and Logstash IP
- Test the Filebeat configuration:
```
filebeat test config
```
- Test Filebeat output:
```
filebeat test output
```
Now that everything has been configured and Filebeat pass both tests, you are ready to proceed to replay the logs to DShield SIEM<br>
