# Managing Elasticsearch Indices

While assigning a certain amount of disk for a docker space, it is also important to review how much data is currently stored in the Elastic database to prevent Elastic from locking you out.<br>

Regularly reviewing what the in Management -> Stack Monitoring, it is possible to quickly review what is currently available for storage. This example shows that 46.87% of the disk is still available for storage.<br>

Note: It is a good idea to keep storage below 85% usage. How to delete data that might no longuer useful?<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/b7bcae79-9f09-4792-83b9-5fdd93f4c900)

## Removing Indice Data

Delete data that isn't critical, review the indices and delete those that are likely non-needed for the analysis of cowrie logs:<br>

* Management -> Stack Management -> Index Management<br>
* Enable Include hidden indices<br>
* Sort by Storage size<br>
* Keep any files that are greater than 000001 -> The system won't allow deleting the indice currently in use by the system<br>
* Select the left square to mark it and Manage index will appear to delete it. Usually something starting with .ds- I don't keep more than a month<br>

**Don't delete anything cowrie**

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/eaaf24c5-f560-440d-aadd-66513be47d0f)
