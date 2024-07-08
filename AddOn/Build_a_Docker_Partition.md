Building a Separate Docker Partition
====================================

This is an example to create a separate docker partition in Linux to mount the drive to:<br>
/var/lib/docker

This setup a 300 GB partition for /var/lib/docker<br>
As root<br>
\# sudo su -<br>

\# cfdisk /dev/sdb<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/1a9db609-fd6f-489e-9bfe-161357720163)

Create the new partition using all the default, write to disk and save the result (quit)<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/e1977c75-af8f-4cc4-9ed7-7f437ce910cf)

Now initializes Physical Volume for later use by the Logical Volume Manager (LVM)<br>
\# pvcreate /dev/sdb1<br>

root@internship4499:~# **vgcreate internship_vg01 /dev/sdb1**<br>
  Volume group "internship_vg01" successfully created<br>

root@internship4499:~# **vgdisplay internship_vg01**<br>
```  --- Volume group ---
  VG Name               internship_vg01
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <300.00 GiB
  PE Size               4.00 MiB
  Total PE              10239
  Alloc PE / Size       0 / 0
  Free  PE / Size       10239 / <300.00 GiB
  VG UUID               w7bKa9-6Y5U-I3sj-hZwG-0nGZ-paJc-D0BKrc
```

[root@NWAPPLIANCE7516 ~]# **lvcreate -n /dev/mapper/internship_vg01-4499 --size 299G internship_vg01**<br>
  Logical volume "4499" created.

root@internship4499:~# **lvdisplay internship_vg01**<br>
```  --- Logical volume ---
  LV Path                /dev/internship_vg01/4499
  LV Name                4499
  VG Name                internship_vg01
  LV UUID                5t2VPy-ZGsR-kUJn-MCQy-VvsW-scsg-L78dp2
  LV Write Access        read/write
  LV Creation host, time internship4499, 2024-01-03 01:48:06 +0000
  LV Status              available
  # open                 0
  LV Size                299.00 GiB
  Current LE             9984
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
```
This step creates the disk to be used for docker<br>

root@internship4499:~# **mkfs.xfs /dev/internship_vg01/4499**
```meta-data=/dev/internship_vg01/4499 isize=512    agcount=4, agsize=2555904 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=10223616, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=4992, version=2
         =                       sectesz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

### Add to /etc/fstab
Edit /etc/fstab and add with either vi or nano this line to mount the new partition, then save and exit<br>

$ sudo vi /etc/fstab<br>
/dev/internship_vg01/4499 /var/lib/docker xfs defaults,noatime,nosuid 0 0<br>

### Setup and Mount the Partition
Create a new directory to mount the new partition

$ sudo mkdir -p /var/lib/docker<br>
$ sudo mount /dev/internship_vg01/4499 /var/lib/docker<br>

## List the mounted partitions<br>
$ df -h<br>
![image](https://github.com/bruneaug/DShield-SIEM/assets/48228401/7ad6f80e-3551-4f22-a279-8929358804ee)



