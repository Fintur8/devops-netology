# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"  
# 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP  
telnet route-views.routeviews.org    
Username: rviews   
route-views>show ip route 109.195.21.216   
Routing entry for 109.195.16.0/20  
  Known via "bgp 6447", distance 20, metric 0  
  Tag 6939, type external  
  Last update from 64.71.137.241 7w0d ago  
  Routing Descriptor Blocks:  
  * 64.71.137.241, from 64.71.137.241, 7w0d ago  
      Route metric is 0, traffic share count is 1   
      AS Hops 3  
      Route tag 6939  
      MPLS label: none  

route-views>show bgp 109.195.21.216  
BGP routing table entry for 109.195.16.0/20, version 45145265  
Paths: (23 available, best #22, table default)  
  Not advertised to any peer  
  Refresh Epoch 1  
  20912 3257 1299 9049 50543  
    212.66.96.126 from 212.66.96.126 (212.66.96.126)  
      Origin incomplete, localpref 100, valid, external  
      Community: 3257:8101 3257:30055 3257:50001 3257:53900 3257:53902 20912:65004  
      path 7FE15DA9D068 RPKI State not found  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  3333 1257 1299 9049 50543  
    193.0.0.56 from 193.0.0.56 (193.0.0.56) 
      Origin incomplete, localpref 100, valid, external  
      Community: 1257:50 1257:51 1257:2000 1257:3528 1257:4103  
      path 7FE0E597E3B8 RPKI State not found  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  8283 1299 9049 50543    
    94.142.247.3 from 94.142.247.3 (94.142.247.3)  
      Origin incomplete, metric 0, localpref 100, valid, external  
      Community: 1299:30000 8283:1 8283:101  
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18  
        value 0000 205B 0000 0000 0000 0001 0000 205B  
              0000 0005 0000 0001  
      path 7FE17BEA8920 RPKI State not found  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  53767 174 174 1299 9049 50543  
    162.251.163.2 from 162.251.163.2 (162.251.162.3)  
      Origin incomplete, localpref 100, valid, external   
      Community: 174:21000 174:22013 53767:5000  
      path 7FE0F0FD84C8 RPKI State not found  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  57866 9002 9049 9049 9049 50543  
    37.139.139.17 from 37.139.139.17 (37.139.139.17)  
      Origin IGP, metric 0, localpref 100, valid, external  
      Community: 9002:0 9002:64667   
      path 7FE022A92C18 RPKI State not found  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  3549 3356 9002 9002 9002 9002 9002 9049 9049 9049 50543  
    208.51.134.254 from 208.51.134.254 (67.16.168.191)  
      Origin IGP, metric 0, localpref 100, valid, external  
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067 3549:2581 3549:30840  
      path 7FE0163372F0 RPKI State not found  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  3356 9002 9002 9002 9002 9002 9049 9049 9049 50543  
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external  
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  20130 6939 9049 50543  
    140.192.8.16 from 140.192.8.16 (140.192.8.16)  
      Origin IGP, localpref 100, valid, external  
      path 7FE0831E63B8 RPKI State not found  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  101 174 1299 9049 50543  
    209.124.176.223 from 209.124.176.223 (209.124.176.223)  
      Origin incomplete, localpref 100, valid, external  
      Community: 101:20100 101:20110 101:22100 174:21000 174:22013  
      Extended Community: RT:101:22100  
      path 7FE163933920 RPKI State not found   
      rx pathid: 0, tx pathid: 0    
 

# 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.  
  
vagrant@vagrant:~$ ip a  
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000  
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00  
    inet 127.0.0.1/8 scope host lo  
       valid_lft forever preferred_lft forever  
    inet6 ::1/128 scope host  
       valid_lft forever preferred_lft forever  
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff  
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0  
       valid_lft 86321sec preferred_lft 86321sec  
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link  
       valid_lft forever preferred_lft forever  
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000  
    link/ether 6e:bc:0d:15:05:26 brd ff:ff:ff:ff:ff:ff  
    inet 10.2.2.2/32 brd 10.2.2.2 scope global dummy0  
       valid_lft forever preferred_lft forever  
    inet6 fe80::6cbc:dff:fe15:526/64 scope link  
       valid_lft forever preferred_lft forever 


vagrant@vagrant:~$ ip route show  
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100  
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15  
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100  
172.16.10.0/24 via 10.0.2.15 dev eth0  
vagrant@vagrant:~$  




# 3 Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.    
vagrant@vagrant:~$ sudo lsof -i -P  
COMMAND    PID            USER   FD   TYPE DEVICE SIZE/OFF NODE NAME  
systemd      1            root   35u  IPv4  16034      0t0  TCP *:111 (LISTEN)  
systemd      1            root   36u  IPv4  16035      0t0  UDP *:111  
systemd      1            root   37u  IPv6  16038      0t0  TCP *:111 (LISTEN)  
systemd      1            root   38u  IPv6  16041      0t0  UDP *:111  
systemd-n  420 systemd-network   19u  IPv4  23634      0t0  UDP vagrant:68  
rpcbind    612            _rpc    4u  IPv4  16034      0t0  TCP *:111 (LISTEN)  
rpcbind    612            _rpc    5u  IPv4  16035      0t0  UDP *:111  
rpcbind    612            _rpc    6u  IPv6  16038      0t0  TCP *:111 (LISTEN)   
rpcbind    612            _rpc    7u  IPv6  16041      0t0  UDP *:111   
systemd-r  613 systemd-resolve   12u  IPv4  21853      0t0  UDP localhost:53  
systemd-r  613 systemd-resolve   13u  IPv4  21854      0t0  TCP localhost:53 (LISTEN)  
sshd       916            root    3u  IPv4  24414      0t0  TCP *:22 (LISTEN)  
sshd       916            root    4u  IPv6  24425      0t0  TCP *:22 (LISTEN)   
sshd       956            root    4u  IPv4  26705      0t0  TCP vagrant:22->_gateway:60623 (ESTABLISHED)    
sshd      1021         vagrant    4u  IPv4  26705      0t0  TCP vagrant:22->_gateway:60623 (ESTABLISHED)    

Судя по выводу:  

1) демон systemd-resolved  слушает порт 53/tcp текущую машину по протоколу DNS.  
2) демон sshd       слушает порт  22/tcp на всех устройсвах по протоколу  SSH  

# 4 роверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?  
1) демон systemd-network  использует порт 68/udp на текущей машине по протоколу  dhcp.  
2) демон systemd-resolved  использует  порт 53/tcp на текущей машину по протоколу DNS.  

