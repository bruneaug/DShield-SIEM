# Managing Elasticsearch Indices

While assigning a certain amount of disk for a docker space, it is also important to review how much data is currently stored in the Elastic database to prevent Elastic from locking you out.<br>

Regularly reviewing what the in Management -> Stack Monitoring, it is possible to quickly review what is currently available for storage. This example shows that 46.87% of the disk is still available for storage.<br>

Note: It is a good idea to keep storage below 85% usage. How to delete data that might no longuer useful?<br>

![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/b7bcae79-9f09-4792-83b9-5fdd93f4c900)

