# Домашнее задание к занятию "3.5. Файловые системы"

# 1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

Очень интересное решение, сколько раз как оказывается я с ними сталкивался (диски для ВМ)

# 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Нет, не могут. Каждая из ссылок - это отдельный файл, но ведут они к одному участку жесткого диска и имеют ту же информацию inode и набор разрешений что и у исходного файла.

# 3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|  
      config.vm.box = "bento/ubuntu-20.04"  
      config.vm.provider :virtualbox do |vb|  
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"  
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"  
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]  
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]  
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]  
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]  
      end  
    end  
    ```  
    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

vagrant@vagrant:~$ lsblk  
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT  
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part /boot/efi  
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /  
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]  
sdb                    8:16   0  2.5G  0 disk  
sdc                    8:32   0  2.5G  0 disk  

# 4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

sudo fdisk /dev/sdb  выполнив данную команду я запустил интерактивный диалог. результат выполнения ниже:  

vagrant@vagrant:~$ lsblk  
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT  
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part /boot/efi  
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /  
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]  
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
└─sdb2                 8:18   0  511M  0 part  
sdc                    8:32   0  2.5G  0 disk  

# 5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

sudo sfdisk -d /dev/sdb | sfdisk /dev/sdc  

Checking that no-one is using this disk right now ... OK  

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors  
Disk model: VBOX HARDDISK  
Units: sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  
I/O size (minimum/optimal): 512 bytes / 512 bytes  

>>> Script header accepted. 
>>> Script header accepted.  
>>> Script header accepted.  
>>> Script header accepted.  
>>> Created a new DOS disklabel with disk identifier 0x8d837661.  
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.  
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.  
/dev/sdc3: Done.  

New situation:  
Disklabel type: dos  
Disk identifier: 0x8d837661  

Device     Boot   Start     End Sectors  Size Id Type  
/dev/sdc1          2048 4196351 4194304    2G 83 Linux  
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux  

The partition table has been altered.  
Calling ioctl() to re-read partition table.  
Syncing disks.  

vagrant@vagrant:~$ lsblk  
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT  
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part /boot/efi  
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /  
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]  
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
└─sdb2                 8:18   0  511M  0 part  
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
└─sdc2                 8:34   0  511M  0 part  

# 6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b1,c1}  

mdadm: partition table exists on /dev/sdb1  
mdadm: partition table exists on /dev/sdb1 but will be lost or  
       meaningless after creating array  
mdadm: Note: this array has metadata at the start and  
    may not be suitable as a boot device.  If you plan to  
    store '/boot' on this device please ensure that  
    your boot-loader understands md/v1.x metadata, or use  
    --metadata=0.90  
mdadm: size set to 2094080K  
Continue creating array? y  
mdadm: Defaulting to version 1.2 metadata  
mdadm: array /dev/md0 started.  
vagrant@vagrant:~$ lsblk  
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT  
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi  
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /  
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]  
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1  
└─sdb2                 8:18   0  511M  0 part  
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1  
└─sdc2                 8:34   0  511M  0 part  

# 7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md0 -l 0 -n 2 /dev/sd{b2,c2}  
mdadm: chunk size defaults to 512K  
mdadm: partition table exists on /dev/sdc2  
mdadm: partition table exists on /dev/sdc2 but will be lost or  
       meaningless after creating array  
Continue creating array? y  
mdadm: Fail create md0 when using /sys/module/md_mod/parameters/new_array  
mdadm: /dev/md0 is already in use.  
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md1 -l 0 -n 2 /dev/sd{b2,c2}  
mdadm: chunk size defaults to 512K  
mdadm: partition table exists on /dev/sdc2  
mdadm: partition table exists on /dev/sdc2 but will be lost or  
       meaningless after creating array  
Continue creating array? y  
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.  
vagrant@vagrant:~$ lsblk  
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT  
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi  
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /  
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]  
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1  
└─sdb2                 8:18   0  511M  0 part  
  └─md1                9:1    0 1018M  0 raid0  
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1  
└─sdc2                 8:34   0  511M  0 part  
  └─md1                9:1    0 1018M  0 raid0  

# 8. Создайте 2 независимых PV на получившихся md-устройствах.

vagrant@vagrant:~$ sudo pvcreate /dev/md0  
  Physical volume "/dev/md0" successfully created.  
vagrant@vagrant:~$ sudo pvcreate /dev/md1  
  Physical volume "/dev/md1" successfully created.  
vagrant@vagrant:~$ sudo pvscan  
  PV /dev/sda5   VG vgvagrant       lvm2 [<63.50 GiB / 0    free]  
  PV /dev/md0                       lvm2 [<2.00 GiB]  
  PV /dev/md1                       lvm2 [1018.00 MiB]  
  Total: 3 [<66.49 GiB] / in use: 1 [<63.50 GiB] / in no VG: 2 [2.99 GiB]  

# 9. Создайте общую volume-group на этих двух PV.

vagrant@vagrant:~$ sudo vgcreate vol_grp1 /dev/md0 /dev/md1  
  Volume group "vol_grp1" successfully created  

vagrant@vagrant:~$ sudo vgdisplay  
  --- Volume group ---  
  VG Name               vgvagrant  
  System ID  
  Format                lvm2  
  Metadata Areas        1  
  Metadata Sequence No  3  
  VG Access             read/write  
  VG Status             resizable  
  MAX LV                0  
  Cur LV                2  
  Open LV               2  
  Max PV                0  
  Cur PV                1  
  Act PV                1  
  VG Size               <63.50 GiB  
  PE Size               4.00 MiB  
  Total PE              16255  
  Alloc PE / Size       16255 / <63.50 GiB  
  Free  PE / Size       0 / 0  
  VG UUID               PaBfZ0-3I0c-iIdl-uXKt-JL4K-f4tT-kzfcyE 

  --- Volume group ---  
  VG Name               vol_grp1  
  System ID  
  Format                lvm2  
  Metadata Areas        2  
  Metadata Sequence No  1  
  VG Access             read/write  
  VG Status             resizable  
  MAX LV                0  
  Cur LV                0  
  Open LV               0  
  Max PV                0  
  Cur PV                2  
  Act PV                2  
  VG Size               <2.99 GiB  
  PE Size               4.00 MiB  
  Total PE              765  
  Alloc PE / Size       0 / 0  
  Free  PE / Size       765 / <2.99 GiB  
  VG UUID               V9Jx3G-9Jcn-BaMf-Zwft-TXBI-ksem-UNd0ZO  

# 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

vagrant@vagrant:~$ sudo lvcreate -L 100M vol_grp1 /dev/md0  
  Logical volume "lvol0" created.  

 vagrant@vagrant:~$ sudo lvs  
  LV     VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert  
  root   vgvagrant -wi-ao---- <62.54g  
  swap_1 vgvagrant -wi-ao---- 980.00m  
  lvol0  vol_grp1  -wi-a----- 100.00m  

# 11. Создайте `mkfs.ext4` ФС на получившемся LV.

vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vol_grp1/lvol0  
mke2fs 1.45.5 (07-Jan-2020)  
Creating filesystem with 25600 4k blocks and 25600 inodes  

Allocating group tables: done  
Writing inode tables: done  
Creating journal (1024 blocks): done  
Writing superblocks and filesystem accounting information: done  

# 12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.  

vagrant@vagrant:~$ mkdir /tmp/new  

vagrant@vagrant:~$ sudo mount /dev/vol_grp1/lvol0 /tmp/new/  

# 13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz  
--2021-12-16 19:18:11--  https://mirror.yandex.ru/ubuntu/ls-lR.gz  
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183  
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.  
HTTP request sent, awaiting response... 200 OK  
Length: 22810646 (22M) [application/octet-stream]  
Saving to: ‘/tmp/new/test.gz’  

/tmp/new/test.gz                      100%[======================================================================>]  21.75M  10.6MB/s    in 2.1s  

2021-12-16 19:18:13 (10.6 MB/s) - ‘/tmp/new/test.gz’ saved [22810646/22810646]  

vagrant@vagrant:~$ ls -l /tmp/new/  
total 22296
drwx------ 2 root root    16384 Dec 16 19:15 lost+found  
-rw-r--r-- 1 root root 22810646 Dec 16 17:22 test.gz  

# 14. Прикрепите вывод `lsblk`.  

vagrant@vagrant:~$ lsblk  
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT  
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi  
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /  
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]  
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1  
│   └─vol_grp1-lvol0 253:2    0  100M  0 lvm   /tmp/new  
└─sdb2                 8:18   0  511M  0 part  
  └─md1                9:1    0 1018M  0 raid0  
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1  
│   └─vol_grp1-lvol0 253:2    0  100M  0 lvm   /tmp/new  
└─sdc2                 8:34   0  511M  0 part  
  └─md1                9:1    0 1018M  0 raid0  

# 15. Протестируйте целостность файла:

    ```bash  
    root@vagrant:~# gzip -t /tmp/new/test.gz  
    root@vagrant:~# echo $?  
    0  
    ```  
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz && echo $?  
0  

# 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.  

vagrant@vagrant:~$ sudo pvmove /dev/md0  
  /dev/md0: Moved: 20.00%  
  /dev/md0: Moved: 100.00%  
vagrant@vagrant:~$ lsblk  
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT  
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi  
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /  
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]  
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1  
└─sdb2                 8:18   0  511M  0 part  
  └─md1                9:1    0 1018M  0 raid0  
    └─vol_grp1-lvol0 253:2    0  100M  0 lvm   /tmp/new  
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1  
└─sdc2                 8:34   0  511M  0 part  
  └─md1                9:1    0 1018M  0 raid0  
    └─vol_grp1-lvol0 253:2    0  100M  0 lvm   /tmp/new  

# 17. Сделайте `--fail` на устройство в вашем RAID1 md.

 sudo mdadm /dev/md0 --fail /dev/sdb1  
mdadm: set /dev/sdb1 faulty in /dev/md0  

vagrant@vagrant:~$ mdadm -D /dev/md0  
mdadm: must be super-user to perform this action  

vagrant@vagrant:~$ sudo mdadm -D /dev/md0  
/dev/md0:  
           Version : 1.2  
     Creation Time : Thu Dec 16 17:31:00 2021  
        Raid Level : raid1  
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)  
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)  
      Raid Devices : 2  
     Total Devices : 2  
       Persistence : Superblock is persistent  

       Update Time : Thu Dec 16 19:52:07 2021  
             State : clean, degraded  
    Active Devices : 1  
   Working Devices : 1  
    Failed Devices : 1  
     Spare Devices : 0  

Consistency Policy : resync  

              Name : vagrant:0  (local to host vagrant)  
              UUID : d2fd98b8:4ede6143:089caeba:1d4bef35  
            Events : 22  

    Number   Major   Minor   RaidDevice State  
       -       0        0        0      removed  
       1       8       33        1      active sync   /dev/sdc1  

       0       8       17        -      faulty   /dev/sdb1  

# 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.  

vagrant@vagrant:~$ dmesg |grep md0  
[54526.930224] md/raid1:md0: not clean -- starting background reconstruction  
[54526.930226] md/raid1:md0: active with 2 out of 2 mirrors  
[54526.930245] md0: detected capacity change from 0 to 2144337920  
[54526.931014] md: resync of RAID array md0  
[54537.833897] md: md0: resync done.  
[57101.848268] md: data-check of RAID array md0  
[57112.410130] md: md0: data-check done.  
[62994.077652] md/raid1:md0: Disk failure on sdb1, disabling device.  
               md/raid1:md0: Operation continuing on 1 devices.  

# 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:  

    ```bash  
    root@vagrant:~# gzip -t /tmp/new/test.gz  
    root@vagrant:~# echo $?  
    0  
    ```  
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz && echo $?  
0  

# 20. Погасите тестовый хост, `vagrant destroy`.  

c:\vagrant>vagrant destroy  
    default: Are you sure you want to destroy the 'default' VM? [y/N] y  
==> default: Forcing shutdown of VM...  
==> default: Destroying VM and associated drives...  
 


