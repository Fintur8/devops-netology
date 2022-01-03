# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"  


# 1.Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.  

Установил. Фото приложил. Что-то похожее уже встроено в  яндекс браузер.  

![bitwarden](https://user-images.githubusercontent.com/72273619/147948408-d662adc3-fb9b-406a-b6d1-f522d1917e28.JPG)

# 2.Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.  

Установил. Фото приложил.
![bitwarden2](https://user-images.githubusercontent.com/72273619/147948423-323fbd1f-8cef-4bc3-85c3-57ce4fa918d3.JPG)


# 3.Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.  

Установка:  
sudo apt install apache2  
sudo a2enmod ssl  
sudo systemctl restart apache2  

Генерация ключа:  
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \  
-keyout /etc/ssl/private/apache-selfsigned.key \   
-out /etc/ssl/certs/apache-selfsigned.crt \  
-subj "/C=RU/ST=Saratov/L=Saratov/O=Company Name/OU=Org/CN=www.aagorpinych.com"  
![ssl-cert](https://user-images.githubusercontent.com/72273619/147948617-78cc55ca-b05a-4b5e-a162-dbf5ed460ad9.JPG)

Настройка сайта:  
sudo nano /etc/apache2/sites-available/y192.168.1.173.conf  
<VirtualHost *:443>  
ServerName 192.168.1.173     
DocumentRoot /var/www/192.168.1.173  
SSLEngine on     
SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt     
SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key  
</VirtualHost>  

Создание тестовой страницы:  
sudo mkdir /var/www/192.168.1.173  
sudo nano /var/www/192.168.1.173/index.html  

Код брал тут https://github.com/cbracco/html5-test-page/blob/master/index.html  
![test-ssl](https://user-images.githubusercontent.com/72273619/147948500-5a0bad70-dafb-4e9e-9382-72debd2c6d78.JPG)

Подключение сайта, проверка конфигурации виртуального хоста, перезагрузка apache2  
sudo a2ensite 192.168.1.173.conf  
sudo apache2ctl configtest  
sudo systemctl reload apache2  

# 4.Проверьте на TLS уязвимости произвольный сайт в интернете   

Проверил фото приложил. 
![tsl](https://user-images.githubusercontent.com/72273619/147949141-ff3e502a-7aee-47ce-8638-6d821448b3fa.JPG)


# 5.Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.  
Устанавливаем  sshd сервер  
apt install openssh-server  
systemctl start sshd.service  
systemctl enable sshd.service  

# Генерируем пару ключей  
ssh-keygen  
 
# копируем публичный ключ на удаленный сервер  
ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub vagrant@192.168.1.254  

vagrant@node1:~$ ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub vagrant@192.168.1.254  
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"  
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed  
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys  
vagrant@192.168.1.254's password:  

Number of key(s) added: 1  

Now try logging into the machine, with:   "ssh 'vagrant@192.168.1.254'"  
and check to make sure that only the key(s) you wanted were added.  

# 6.Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

Переименовываем файлы ключей:  
vagrant@node1:~$ cd /home/vagrant/.ssh/    
vagrant@node1:~/.ssh$ ls  
authorized_keys  id_rsa  id_rsa.pub  known_hosts  
vagrant@node1:~/.ssh$ mv id_rsa node1_rsa  
vagrant@node1:~/.ssh$ mv id_rsa.pub node1_rsa.pub  
vagrant@node1:~/.ssh$ ls  
authorized_keys  node1_rsa  node1_rsa.pub  known_hosts  

Создаем файл конфигурации клиента:   
vagrant@node1: touch ~/.ssh/config && chmod 600 ~/.ssh/config   

vagrant@node1: ~/.ssh$ ls -lh  
total 16K  
-rw------- 1 vagrant vagrant   65 Jan  3 13:43 config  
-rw-r--r-- 1 vagrant vagrant  222 Jan  3 13:16 known_hosts  
-rw------- 1 vagrant vagrant 2.6K Jan  3 13:39 node1_rsa  
-rw-r--r-- 1 vagrant vagrant  567 Jan  3 13:39 node1_rsa.pub  

vagrant@node1: nano ~/.ssh/config 

Добавляем в конфиг файл :  
Host node2  
HostName 192.168.1.254  
IdentityFile ~/.ssh/node1_rsa  

# 7.Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

 sudo tcpdump -c 100 -w 2.pcap -i eth1
 ![wireshark](https://user-images.githubusercontent.com/72273619/147949502-92a1de47-496e-4cbd-8052-ab196991580b.JPG)

 
