# Задача 1
Опишите своими словами основные преимущества применения на практике IaaC паттернов.
---
	Основным преимуществом применения паттернов IaaC является организация 
	процесса разработки, тестирование и развертывания ПО непрерывно и в автоматическом режиме, 
	что в свою очередь позволяет сократить срок выпуска продукта и повысить его качество.  
	В общем скорость, экономичность, уменьшение риск, воспроизводимость и масштабируемость. 

Какой из принципов IaaC является основополагающим?
---
```
Основополагающим принципом IaaC является идемпотентность - это возможность получить понятный, 
предсказуемый и воспроизводимый результат.  
```
# Задача 2
Чем Ansible выгодно отличается от других систем управление конфигурациями?
---
```
Простой синтаксис
Легкое и быстрое развертывание
Использование Модулей Ansible
```
	
Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
---
```
На мой взгляд Push надёжней, т.к. централизованно управляет конфигурацией 
и исключает ситуации изменения конфигурация на стороне управляемого сервера.	
```
# Задача 3
Установить на личный компьютер:
---
```
	VirtualBox
	sudo apt install gcc make linux-headers-$(uname -r) dkms
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
	sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list.d/virtualbox.list'
	sudo apt update
	sudo apt install virtualbox
```
```  
	Vagrant
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	sudo apt-get update && sudo apt-get install vagrant
```
```
	Ansible
	sudo apt install ansible
	sudo mkdir -p /etc/ansible/hosts
```	

Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.
---
```
	alex@testsrv:~$ vboxmanage --version
	6.1.26_Ubuntur145957
```
```
	alex@testsrv:~$  vagrant --version
	Vagrant 2.2.19
```
```
	 alex@testsrv:~$ sudo ansible --version
	 ansible 2.10.8
  	config file = None
  	configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  	ansible python module location = /usr/lib/python3/dist-packages/ansible
  	executable location = /usr/bin/ansible
  	python version = 3.9.7 (default, Sep 10 2021, 14:59:43) [GCC 11.2.0]
```
