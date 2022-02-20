## Домашнее задание к занятию 5.5.
<details><summary>Задачи</summary>

## Задача 1
<details><summary>Раскрой меня</summary>

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?
	
</details> 	
<details><summary>Ответ</summary>

```
replication позволяет создать необходимое нам количество реплик сервисов в кластере в ручном режиме
	
global автоматически запускает одну и туже задачу на каждом узле кластера.
Это также работает при добавлении новых узлов в кластер. 
```
```
При выборе лидера в Docker Swarm кластере используется алгоритм Raft
```
	
```
Overlay Network это сетевой драйвер для соединения несколько демонов Docker между собой 
и который позволяет docker-swarm службам взаимодействовать друг с другом напрямую без выполнения маршрутизации.
```
</details>

## Задача 2
<details><summary>Раскрой меня</summary>

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
</details>
<details><summary>Ответ</summary>

<p align="center">
  <img width="974" height="330" src="https://user-images.githubusercontent.com/72273619/154843777-1755c3d0-dc4a-4326-973a-bf27eba3e480.JPG">
</p>
</details>

## Задача 3
<details><summary>Раскрой меня</summary>

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

</details>

<details><summary>Ответ</summary>

<p align="center">
  <img width="1545" height="330" src="https://user-images.githubusercontent.com/72273619/154843897-5512c22f-7ecd-43c5-bc28-2f2f557c2a89.JPG">
</p>
</details>
	
## Задача 4
<details><summary>Раскрой меня</summary>

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```
</details>

<details><summary>Ответ</summary>

```
Данная команда Docker предназначена для включения функции защиты общего ключа шифрования TLS и ключа,
используемого для шифрования и расшифровки логов алгоритма Raft, 
позволяет нам стать владельцем этих ключей и требовать ручной разблокировки наших менеджеров.
```
	
</details>

</details> 

## Домашнее задание к занятию 5.4.
<details><summary>Задачи</summary>

## Задача 1
<details><summary>Раскрой меня</summary>

Создать собственный образ операционной системы с помощью Packer.

Для получения зачета, вам необходимо предоставить:
- Скриншот страницы, как на слайде из презентации (слайд 37).
</details> 
<details><summary>Ответ</summary>
<p align="center">
  <img width="1200" height="600" src="https://user-images.githubusercontent.com/72273619/153776253-18560d80-22eb-4f56-af80-a4afbf3a53e0.JPG">
</p>
<p align="center">
  <img width="1200" height="600" src="https://user-images.githubusercontent.com/72273619/153776371-be48ecfe-0da8-4190-ad03-d35b189c9c5a.JPG">
</p>
</details> 	
	
## Задача 2
	
<details><summary>Раскрой меня</summary>
Создать вашу первую виртуальную машину в Яндекс.Облаке.

Для получения зачета, вам необходимо предоставить:
- Скриншот страницы свойств созданной ВМ, как на примере ниже:

<p align="center">
  <img width="1200" height="600" src="https://user-images.githubusercontent.com/72273619/153776349-16e870ff-077d-4443-995c-2bd8a5d1fce6.JPG">
</p>
</details>

<details><summary>Ответ</summary>
<p align="center">
  <img width="1200" height="600" src="https://user-images.githubusercontent.com/72273619/153776401-1c16dc53-0caf-4ae9-95f2-9cec4c01cbae.JPG">
</p>
</details> 
	
## Задача 3
	
<details><summary>Раскрой меня</summary>
Создать ваш первый готовый к боевой эксплуатации компонент мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить:
- Скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже
<p align="center">
  <img width="1200" height="600" src="./assets/yc_02.png">
</p>
</details> 
	
<details><summary>Ответ</summary>
<p align="center">
  <img width="1200" height="600" src="https://user-images.githubusercontent.com/72273619/153776558-6c1183be-fd76-46c3-bec5-6312e080a52d.JPG">
</p>
</details>
	
## Задача 4 (*)
	
<details><summary>Раскрой меня</summary>
Создать вторую ВМ и подключить её к мониторингу развёрнутому на первом сервере.

Для получения зачета, вам необходимо предоставить:
- Скриншот из Grafana, на котором будут отображаться метрики добавленного вами сервера.
</details> 
	
<details><summary>Ответ</summary>
<p align="center">
  <img width="1200" height="600" src="https://user-images.githubusercontent.com/72273619/153776616-48924434-0c7a-4fa7-ba4d-feffa67b787a.JPG">
</p>
	
</details>
	
</details> 

## Домашнее задание к занятию 5.3
<details><summary>Задачи</summary>
 
## Задача 1
 
<details><summary>Раскрой меня</summary>
Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
</details>
 <details><summary>Ответ</summary>
  
  https://hub.docker.com/repository/docker/gorpinychaa/test
  
</details>
 
## Задача 2
<details><summary>Раскрой меня</summary>
Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
 
</details>
 
 <details><summary>Ответ</summary>
  
Высоконагруженное монолитное java веб-приложение:
 --
Предполагаю, что нужен физический сервер так как приложение монолитное и высоконагруженное,  
а любые прослойки в ввиде гипервизоров дадут свою нагрузку и лишние отнимут некоторое количество ресурсов.  
Так же использование Docker-a направлено в сторону микросервисной архитектуры, что является полной противоположностью монолитной архитектуры.  

Nodejs веб-приложение:
--
Тут можно использовать несколько сценариев, но главный из них docker так как он масштабируемый и прекрасно подойдет для микросервисной архитектуры,  
а так же позволит быстро развернуть приложение со всеми необходимыми зависимостями.  
    
Мобильное приложение c версиями для Android и iOS:
--
Не совсем возможно понял, но для тестирования приложений для андроид нужно либо само устройство или его эмулятор (виртуальная машина)   
и похоже что docker врятли с этим справится, хотя есть несколько проектов https://github.com/budtmo/docker-android.   

Шина данных на базе Apache Kafka:
--
Как я понял изразличных статей, можно с легкостью развернуть в контейнерах, но для отказоустойчивости и сохранения критичных данных лучше подойдет виртуалка.  
 
Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana:
--
Предполагаю что тут применимы 2 варианта,либо docker либо виртуальная машина. для детализации выбора очень мало опыта. Судя по статьям, так и есть.  

Мониторинг-стек на базе Prometheus и Grafana:
--
Однозначно docker. Позволяет быстро разворачиватья + масштабирование.  

MongoDB, как основное хранилище данных для java-приложения:
--
Лучше использовать Виртуальную машину, т.к. хранилище в контейнере лучше не хранить БД с данными, но и docker sтоже подойдет.  

Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry:
--
Думаю удобней будет виртуальная машина, так сервер GitLab не придется масштабировать и обновлять каждый день. Появится возможность с легкостью обслуживать данный сервис(бэкапы и организация отказоустойчивости)

  
</details> 
 
## Задача 3
 
<details><summary>Раскрой меня</summary>
 
- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

</details>
 
  <details><summary>Ответ</summary>
  
	vagrant@server1:~/data$ docker run -it -d --name centos -v $(pwd)/data:/data centos:latest
	Unable to find image 'centos:latest' locally
	latest: Pulling from library/centos
	a1d0c7532777: Pull complete
	Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
	Status: Downloaded newer image for centos:latest
	966515539bd7745cfd481710c9ad2c995283c2c109127491459a4481d8fc17e4

	vagrant@server1:~$ docker run -it -d --name debian -v $(pwd)/data:/data debian:latest
	Unable to find image 'debian:latest' locally
	latest: Pulling from library/debian
	282deafaaa63: Pull complete
	Digest: sha256:4771808bf8178f6570b1c3bc6a36b72588bb86079529fdd464ab02377cfc9a00
	Status: Downloaded newer image for debian:latest
	f7fc8f1a12dada867301e9b93e1a20b280e21405fd94a6f9534532a8895cdf5b

	vagrant@server1:~$ docker ps
	CONTAINER ID   IMAGE           COMMAND       CREATED              STATUS              PORTS     NAMES
	f7fc8f1a12da   debian:latest   "bash"        17 seconds ago       Up 11 seconds                 debian
	133efde188c9   centos:latest   "/bin/bash"   About a minute ago   Up About a minute             centos

	vagrant@server1:~$ docker exec -it centos bash
	[root@133efde188c9 /]# echo "Hellow, world!" > /data/centos.txt
	[root@133efde188c9 /]# exit
	exit

	vagrant@server1: cat /data/centos.txt
	Hellow, world!
	vagrant@server1:~/data$ docker exec -it debian bash
	root@f7fc8f1a12da:/# exit
	exit

	vagrant@server1:~/data$ echo "Hellow, world!" >> /home/vagrant/data/host.txt
	vagrant@server1:~/data$ ls
	centos.txt  host.txt
	vagrant@server1:~/data$ docker exec -it debian bash
	root@f7fc8f1a12da:/# ls -l /data/
	total 8
	-rw-r--r-- 1 root root 28 Feb  3 21:27 centos.txt
	-rw-rw-r-- 1 1000 1000 27 Feb  3 21:33 host.txt
</details>
 
## Задача 4 (*)
 
<details><summary>Раскрой меня</summary>
 
Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

---
 
</details>
 
 <details><summary>Ответ</summary>
  
  https://hub.docker.com/repository/docker/gorpinychaa/ansible
  
</details>
 
</details>


---
