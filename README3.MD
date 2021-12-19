#  1.Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?  
На моей виртуалке 2 интерфейса:   

vagrant@vagrant:~$ ip -s link  
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000  
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00  
    RX: bytes  packets  errors  dropped overrun mcast  
    46181      529      0       0       0       0  
    TX: bytes  packets  errors  dropped carrier collsns  
    46181      529      0       0       0       0   
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000  
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff  
    RX: bytes  packets  errors  dropped overrun mcast  
    230882935  164886   0       0       0       0  
    TX: bytes  packets  errors  dropped carrier collsns  
    6146312    86717    0       0       0       0  

vagrant@vagrant:~$ networkctl  
IDX LINK TYPE     OPERATIONAL SETUP  
  1 lo   loopback carrier     unmanaged  
  2 eth0 ether    routable    configured  

2 links listed.  

# По коммандам :  
в Linux обычно использую "ip", но гугл еще советует "ls /sys/class/net" и "cat /proc/net/dev"  

в Windows обычно использую "ipconfig" либо можно "netsh interface show interface"  

Хотел задать вопрос. Вот для чего используются loopback адреса? не могу понять..    

#  2.Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?  

Для этого используется протокол Link Layer Discovery Protocol (LLDP) — протокол канального уровня, который позволяет сетевым устройствам анонсировать в сеть   информацию о себе и о своих возможностях, а также собирать эту информацию о соседних устройствах.  
Используется пакет lldpd. Основная комманда lldpctl.   

#  3.Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.  
Для разделения L2 коммутатора на несколько виртуальных сетей используется технология VLAN(802.1Q).   
Для работы VLAN в Linux используется пакет "vlan"  
Для настройки необходимо соблюсти несколько условий :   

  1) Установить нужный пакет "sudo apt install vlan"    
  2)Убедится что загружен драйвер модуля ядра Linux (8021q) "lsmod | grep 8021q" и если его нет, то запустить " sudo modprobe 8021q"  
  3) Далее необходимо настроить файл "/etc/network/interfaces" Добавив строки ниже:  

auto vlan1400  
iface vlan1400 inet static  
        address 10.168.1.1  
        netmask 255.255.255.0  
        vlan_raw_device eth0  

или   

auto eth0.1400  
iface eth0.1400 inet static  
        address 192.168.1.1  
        netmask 255.255.255.0  
        vlan_raw_device eth0  


#  4.Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

в Linux существует один тип агрегации портов: .LAG – агрегация портов он же bonding.


balance-rr or 0, active-backup or 1,balance-xor or 2, broadcast or 3, 802.3ad or 4, balance-tlb or 5, balance-tlb or 5

 Для настройки файл "/etc/network/interfaces" 

auto bond0  
iface bond0 inet static  
    address 10.168.1.150  
    netmask 255.255.255.0  
    gateway 10.168.1.1    
    dns-nameservers 10.168.1.1 8.8.8.8  
    dns-searc h domain.local  
        slaves eth0 eth1  
        bond_mode 0  
    
# 5.Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

Всего адресов:	8  
Кол-во хостов:	6  

 из сети с маской /24 можно получить  32 подсети с маской /29  

10.10.10.1/29  
10.10.10.8/29  
10.10.10.16/29  

# 6.Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.  

Можно взять из Carrier-Grade NAT. 100.64.0.0 — 100.127.255.255  /10   

для Примера 100.64.0.1/26   

#  7.Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?  
В Linux : sudo arp-scan --interface=eth0  

В Windows: "arp -a"  

Для очистки: Linux "ip neigh flush dev "и "ip neigh show"   

В Windows: "netsh interface ip delete arpcache"  
 
Для удаления в Linux: "sudo ip neigh del dev eth0 10.0.2.2"  
Для удаления в Windows: "arp -d 192.168.1.1  






