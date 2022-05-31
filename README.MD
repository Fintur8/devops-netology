## Домашнее задание к занятию 6.2.

<details><summary>Задачи</summary>

## Задача 1

<details><summary>Раскрой меня</summary>
	
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.	

</details> 

<details><summary>Ответ</summary>
	
	version: '3'
	services:
  	 db2:
    	 container_name: postgresql_01
    	 image: 'postgres:12'
	 restart: always
    	 ports:
    	   - 5432:5432
    	environment:
        	POSTGRES_USER: test
        	POSTGRES_PASSWORD: vg52xgt72!
        	POSTGRES_DB: test_db
    	volumes:
        	- /home/alex/test/db_data/:/var/lib/postgresql/data/
        	- /home/alex/test/db_backup/:/var/lib/postgresql/backup/
</details>

## Задача 2

<details><summary>Раскрой меня</summary>
	
В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db
	
</details> 

<details><summary>Ответ</summary>

## 1
	test_db=# \l
				     List of databases
	   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
	-----------+-------+----------+------------+------------+-------------------
	 postgres  | test  | UTF8     | en_US.utf8 | en_US.utf8 |
	 template0 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
		   |       |          |            |            | test=CTc/test
	 template1 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
		   |       |          |            |            | test=CTc/test
	 test_db   | test  | UTF8     | en_US.utf8 | en_US.utf8 |
	(4 rows)
## 2	
	test_db=# \d orders
					       Table "public.orders"
	    Column    |          Type          | Collation | Nullable |              Default
	--------------+------------------------+-----------+----------+------------------------------------
	 id           | integer                |           | not null | nextval('orders_id_seq'::regclass)
	 наименование | character varying(255) |           |          |
	 цена         | integer                |           |          |
	Indexes:
	    "orders_pkey" PRIMARY KEY, btree (id)
	Referenced by:
	    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

## 3
	test_db=# \d clients
						 Table "public.clients"
	      Column       |          Type          | Collation | Nullable |               Default
	-------------------+------------------------+-----------+----------+-------------------------------------
	 id                | integer                |           | not null | nextval('clients_id_seq'::regclass)
	 фамилия           | character varying(255) |           |          |
	 страна_проживания | character varying(255) |           |          |
	 заказ             | integer                |           |          |
	Indexes:
	    "clients_pkey" PRIMARY KEY, btree (id)
	    "city" btree ("страна_проживания")
	Foreign-key constraints:
	    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

## 4
	test_db=#  select grantee, table_catalog, table_name,  privilege_type  from information_schema.table_privileges where table_name='orders' or table_name='clients';
	     grantee      | table_catalog | table_name | privilege_type
	------------------+---------------+------------+----------------
	 test             | test_db       | orders     | INSERT
	 test             | test_db       | orders     | SELECT
	 test             | test_db       | orders     | UPDATE
	 test             | test_db       | orders     | DELETE
	 test             | test_db       | orders     | TRUNCATE
	 test             | test_db       | orders     | REFERENCES
	 test             | test_db       | orders     | TRIGGER
	 test_admin_user  | test_db       | orders     | INSERT
	 test_admin_user  | test_db       | orders     | SELECT
	 test_admin_user  | test_db       | orders     | UPDATE
	 test_admin_user  | test_db       | orders     | DELETE
	 test_admin_user  | test_db       | orders     | TRUNCATE
	 test_admin_user  | test_db       | orders     | REFERENCES
	 test_admin_user  | test_db       | orders     | TRIGGER
	 test_simple_user | test_db       | orders     | INSERT
	 test_simple_user | test_db       | orders     | SELECT
	 test_simple_user | test_db       | orders     | UPDATE
	 test_simple_user | test_db       | orders     | DELETE
	 test             | test_db       | clients    | INSERT
	 test             | test_db       | clients    | SELECT
	 test             | test_db       | clients    | UPDATE
	 test             | test_db       | clients    | DELETE
	 test             | test_db       | clients    | TRUNCATE
	 test             | test_db       | clients    | REFERENCES
	 test             | test_db       | clients    | TRIGGER
	 test_admin_user  | test_db       | clients    | INSERT
	 test_admin_user  | test_db       | clients    | SELECT
	 test_admin_user  | test_db       | clients    | UPDATE
	 test_admin_user  | test_db       | clients    | DELETE
	 test_admin_user  | test_db       | clients    | TRUNCATE
	 test_admin_user  | test_db       | clients    | REFERENCES
	 test_admin_user  | test_db       | clients    | TRIGGER
	 test_simple_user | test_db       | clients    | INSERT
	 test_simple_user | test_db       | clients    | SELECT
	 test_simple_user | test_db       | clients    | UPDATE
	 test_simple_user | test_db       | clients    | DELETE
</details>

## Задача 3

<details><summary>Раскрой меня</summary>

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

</details>
	
<details><summary>Ответ</summary>
	
	alter table clients rename COLUMN фамилия to ФИО;
	INSERT INTO orders (наименование, цена) values ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
	INSERT INTO clients (ФИО, страна_проживания) values ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');

## 1
	test_db=# select count (*) from clients;
	 count
	-------
	     5
	(1 row)

## 2
	test_db=# select count (*) from orders;
	 count
	-------
	    10
	(1 row)
	
</details>

## Задача 4

<details><summary>Раскрой меня</summary>

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

</details>

<details><summary>Ответ</summary>
	
	UPDATE clients SET заказ = 4 where id = 2;
	UPDATE clients SET заказ = 5 where id = 3;
	UPDATE clients SET заказ = 3 where id = 1


	test_db=# SELECT * from clients where заказ is not null;
	
	 id |         ФИО          | страна_проживания | заказ
	----+----------------------+-------------------+-------
	  1 | Иванов Иван Иванович | USA               |     3
	  2 | Петров Петр Петрович | Canada            |     4
	  3 | Иоганн Себастьян Бах | Japan             |     5

</details>
	
## Задача 5

<details><summary>Раскрой меня</summary>

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

</details>

<details><summary>Ответ</summary>

	test_db=# EXPLAIN SELECT * from clients where заказ is not null;
				 QUERY PLAN
	------------------------------------------------------------
	 Seq Scan on clients  (cost=0.00..10.70 rows=70 width=1040)
	   Filter: ("заказ" IS NOT NULL)
	(2 rows)

	EXPLAIN сообщает, что используется Seq Scan — последовательное, блок за блоком, чтение данных таблицы clients  
	cost показывает стоимость получения первой строки и общую стоимость получения всех строк
	rows — приблизительное количество возвращаемых строк при выполнении операции Seq Scan. Это значение возвращает планировщик. В моём случае оно не совпадает с реальным количеством строк в таблице.
	width — средний размер одной строки в байтах.
	Filter - указывает на примененое условие к выборке
	(2 rows) - предполагаю что указывает на количество отброшенных строк не подходящих под фильтр.
</details>

## Задача 6
<details><summary>Раскрой меня</summary>

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

</details>
	
<details><summary>Ответ</summary>
	sudo docker-compose up -d

	pg_dump -h 0.0.0.0 -U test test_db > /home/alex/sql2/db_backup/test_db.dump

	alex@testfin:~/test$ psql -h 0.0.0.0 -U test -d postgres

	CREATE USER test_admin_user;
	ALTER USER test_admin_user WITH PASSWORD 'cisco!';

	CREATE USER test_simple_user; 
	ALTER USER ALTER USER test_simple_user WITH PASSWORD 'cisco!';

	postgres=# create database test_db;

	postgres=# exit;

	psql -h 0.0.0.0 -U test test_db < /home/alex/sql2/db_backup/test_db.dump
</details>	

</details>	
	
	
## Домашнее задание к занятию 6.1.

<details><summary>Задачи</summary>
	
## Задача 1

<details><summary>Раскрой меня</summary>
	
Архитектор ПО решил проконсультироваться у вас, какой тип БД лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

    Электронные чеки в json виде
    Склады и автомобильные дороги для логистической компании
    Генеалогические деревья
    Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
    Отношения клиент-покупка для интернет-магазина

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.
</details> 

<details><summary>Ответ</summary>

    Электронные чеки в json виде

Документо-ориентированые БД, например, MongoDB, так как она хранит документы в формате JSON 

    Склады и автомобильные дороги для логистической компании

Можно использовать графовую БД, для примера поплярная Neo4j, так как  с нам необходимо по сути оптимизировать путь от точки А до точки Б

    Генеалогические деревья

Можно использовать сетевые БД, например, IDS

    Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутентификации

можно использовать БД Ключ-значение, для примера, Memcached, так как данные хранятся в RAM, есть настройки TTL

    Отношения клиент-покупка для интернет-магазина

однозначно лучше использовать реляционные БД, например, Postgres/MySQL, так как  табличное представление позволит масштабировать данное решение

</details>

## Задача 2
	
<details><summary>Раскрой меня</summary>

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если (каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

    Данные записываются на все узлы с задержкой до часа (асинхронная запись)
    При сетевых сбоях, система может разделиться на 2 раздельных кластера
    Система может не прислать корректный ответ или сбросить соединение

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?
</details> 

<details><summary>Ответ</summary>

Данные записываются на все узлы с задержкой до часа (асинхронная запись)

	PA, PC/EL

При сетевых сбоях, система может разделиться на 2 раздельных кластера

	CA, PA/EC

Система может не прислать корректный ответ или сбросить соединение

	PC, PC/EC

</details>

## Задача 3

<details><summary>Раскрой меня</summary>

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?
</details> 

<details><summary>Ответ</summary>
	
	Не могут, так как принципы противоречат друг другу. 
	BASE отдает приоритет высокой производительности/доступности в ущерб согласованности данных.
	Главное разногласие в требовании согласованности.
	ACID требует немедленной согласованности, BASE согласованности в какой-то момент времени в будущем, и согласованность
	может обеспечиваться не механизмами БД, а средствами разработки.
	
</details>

## Задача 4

<details><summary>Раскрой меня</summary>

Вам дали задачу написать системное решение, основой которого бы послужили:

    фиксация некоторых значений с временем жизни
    реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм Pub/Sub. Что это за система? Какие минусы выбора данной системы?
</details> 

<details><summary>Ответ</summary>
	
	Наиболее подходящим решением в данной ситуации будет использование  Redis. Redis это key-value хранилище, имеет механизм
	Pub/Sub и TTL с возможностью реакции на его истечение.
	минусы Redis:
	- Высокие требования к оперативной памяти сервера
	- Консистентность данных - в случае отказа сервера, данные из оперативной памяти будут утеряны и сохранятся только данные 
	с последней синхронизации с диском
	- Отсутствует разграничение прав доступа по пользователям.
	- Отсутствует поддержка языка SQL
	- Экземпляр БД не маштабируется
	- Работает только на одном ядре процессора в однопоточном режиме
	
</details>

</details>

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
