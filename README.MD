## Домашнее задание к занятию 6.6.

<details><summary>Задачи</summary>

## Задача 1
	
<details><summary>Раскрой меня</summary>

</details> 
	
<details><summary>Ответ</summary>


</details> 

## Задача 2
	
<details><summary>Раскрой меня</summary>

</details> 
	
<details><summary>Ответ</summary>


</details> 

## Задача 3
	
<details><summary>Раскрой меня</summary>

</details> 
	
<details><summary>Ответ</summary>


</details> 

## Задача 4
	
<details><summary>Раскрой меня</summary>

</details> 
	
<details><summary>Ответ</summary>


</details> 
	
</details> 

## Домашнее задание к занятию 6.5.

<details><summary>Задачи</summary>

## Задача 1
	
<details><summary>Раскрой меня</summary>
В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.
</details> 
	
<details><summary>Ответ</summary>
текст Dockerfile манифеста: 

	RUN export ES_HOME="/var/lib/elasticsearch"
	RUN yum install -y epel-release && yum install -y perl-Digest-SHA
	RUN yum clean all
	ADD elasticsearch-8.2.3-linux-x86_64.tar.gz
	RUN mv elasticsearch-8.2.3 ${ES_HOME}
	ADD elasticsearch.yml ${ES_HOME}/config/
	RUN groupadd elastic && useradd -g elastic elastic
	RUN mkdir /var/lib/logs && chown elastic:elastic /var/lib/logs && mkdir /var/lib/data && chown elastic:elastic /var/lib/data && chown -R elastic:elastic ${ES_HOME}

	USER elastic

	ENV ES_HOME="/var/lib/elasticsearch" \
	    ES_PATH_CONF="/var/lib/elasticsearch/config"
	WORKDIR ${ES_HOME}

	CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]	

[Ссылка на 'dockerhub'](https://hub.docker.com/r/gorpinychaa/els/tags)

ответ `elasticsearch` на запрос пути `/` в json виде
	
	alex@testfin:~/myelastic$ curl -XGET 'localhost:9200/'
	{
	  "name" : "netology_test",
	  "cluster_name" : "my-netology-cluster",
	  "cluster_uuid" : "QSjvw7i9QP6KrNxTi3uhoA",
	  "version" : {
	    "number" : "8.2.3",
	    "build_flavor" : "default",
	    "build_type" : "tar",
	    "build_hash" : "9905bfb62a3f0b044948376b4f607f70a8a151b4",
	    "build_date" : "2022-06-08T22:21:36.455508792Z",
	    "build_snapshot" : false,
	    "lucene_version" : "9.1.0",
	    "minimum_wire_compatibility_version" : "7.17.0",
	    "minimum_index_compatibility_version" : "7.0.0"
	  },
	  "tagline" : "You Know, for Search"
	}

</details> 

## Задача 2
	
<details><summary>Раскрой меня</summary>

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

</details> 
	
<details><summary>Ответ</summary>

Добавляем в `elasticsearch` 3 индекса, в соответствии со таблицей:

	curl  -X PUT http://localhost:9200/ind-1?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'

	curl -X PUT http://localhost:9200/ind-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 2, "number_of_replicas": 1 }}}'

	curl -X PUT http://localhost:9200/ind-3?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 4, "number_of_replicas": 2 }}}'

Получаем список индексов и их статусов, используя API:

	alex@testfin:~$ curl -XGET 'localhost:9200/_cat/indices?v'
	health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
	green  open   ind-1 Rbafqvk4RDWb4VOuKyY82g   1   0          0            0       225b           225b
	yellow open   ind-2 JS38PFL2QviC8BpbJMqy1Q   2   1          0            0       450b           450b
	yellow open   ind-3 XG4sr9F2SJipV4gzXrtyFw   4   2          0            0       225b           225b



Получаем состояние кластера `elasticsearch`, используя API:
	
	curl http://localhost:9200/_cluster/health?pretty

	alex@testfin:~$ curl http://localhost:9200/_cluster/health?pretty
	{
	  "cluster_name" : "my-netology-cluster",
	  "status" : "yellow",
	  "timed_out" : false,
	  "number_of_nodes" : 1,
	  "number_of_data_nodes" : 1,
	  "active_primary_shards" : 8,
	  "active_shards" : 8,
	  "relocating_shards" : 0,
	  "initializing_shards" : 0,
	  "unassigned_shards" : 10,
	  "delayed_unassigned_shards" : 0,
	  "number_of_pending_tasks" : 0,
	  "number_of_in_flight_fetch" : 0,
	  "task_max_waiting_in_queue_millis" : 0,
	  "active_shards_percent_as_number" : 44.44444444444444


Состояние yellow у кластера связано с тем, что присутствуют unassigned шарды.

Удаление индексов:

	alex@testfin:~$ curl -X DELETE http://localhost:9200/ind-3?pretty
	{
	  "acknowledged" : true
	}
	alex@testfin:~$ curl -X DELETE http://localhost:9200/ind-2?pretty
	{
	  "acknowledged" : true
	}
	alex@testfin:~$ curl -X DELETE http://localhost:9200/ind-1?pretty
	{
	  "acknowledged" : true
	}

</details> 	

## Задача 3
	
<details><summary>Раскрой меня</summary>

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

</details> 
	
<details><summary>Ответ</summary>

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`:
	
	alex@testfin:~/myelastic$ sudo docker exec -it 7aead33f5d9d pwd
	/var/lib/elasticsearch


	alex@testfin:~/myelastic$ sudo docker exec -it 7aead33f5d9d ls -lha
	total 912K
	drwxr-xr-x 1 elastic elastic 4.0K Jun 20 11:07 .
	drwxr-xr-x 1 root    root    4.0K Jun 20 11:05 ..
	-rw-r--r-- 1 elastic elastic 3.8K Jun  8 22:21 LICENSE.txt
	-rw-r--r-- 1 elastic elastic 853K Jun  8 22:25 NOTICE.txt
	-rw-r--r-- 1 elastic elastic 2.7K Jun  8 22:21 README.asciidoc
	drwxr-xr-x 1 elastic elastic 4.0K Jun  8 22:27 bin
	drwxr-xr-x 1 elastic elastic 4.0K Jun 20 11:07 config
	drwxr-xr-x 1 elastic elastic 4.0K Jun  8 22:27 jdk
	drwxr-xr-x 1 elastic elastic 4.0K Jun  8 22:27 lib
	drwxr-xr-x 1 elastic elastic 4.0K Jun 20 11:07 logs
	drwxr-xr-x 1 elastic elastic 4.0K Jun  8 22:28 modules
	drwxr-xr-x 1 elastic elastic 4.0K Jun  8 22:25 plugins
	drwxr-xr-x 3 elastic elastic 4.0K Jun 20 11:22 snapshots


Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`:

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.
	
	curl -X PUT http://localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d '{ "type": "fs", "settings": { "location": "/var/lib/elasticsearch/snapshots"}}'


	alex@testfin:~/myelastic$ curl -X PUT http://localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d '{ "type": "fs", "settings": { "location": "/var/lib/elasticsearch/snapshots"}}'
	{
	  "acknowledged" : true
	}

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов: 
	
	curl  -X PUT http://localhost:9200/test?pretty -H 'Content-Type: application/json' -d 
	'{ 
	"settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}
	}'

	curl -XGET 'localhost:9200/_cat/indices?v'

	alex@testfin:~/myelastic$ curl -XGET 'localhost:9200/_cat/indices?v'
	health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
	green  open   test  vhZyY8_mS2aH9aifycHq2w   1   0          0            0       225b           225b



[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`:

	curl  -X PUT http://localhost:9200/_snapshot/netology_backup/snapshot_elasticsearch?wait_for_completion=true -H 'Content-Type: application/json' -d 
	'{
	"indices": "test", 
	"ignore_unavailable": true, 
	"include_global_state": false, 
	"metadata": { "taken_by": "Alex", "taken_because": "first backup testing" }
	}'


	alex@testfin:~/myelastic$ curl  -X PUT http://localhost:9200/_snapshot/netology_backup/snapshot_elasticsearch?wait_for_completion=true -H 'Content-Type: application/json' -d 
	'{
	"indices": "test", 
	"ignore_unavailable": true, 
	"include_global_state": false, 
	"metadata": { "taken_by": "Alex", "taken_because": "first backup testing" }
	}'

	{
	"snapshot":"snapshot_elasticsearch",
	"uuid":"4zKz_xRbTo2YkM02zhOL0A",
	"repository":"netology_backup",
	"version_id":8020399,
	"vnclude_global_state":false,
	"metadata":{"taken_by":"Alex","taken_because":"first backup testing"},
	"state":"SUCCESS","start_time":"2022-05,
	"end_time":"2022-06-20T11:22:09.885Z",
	"end_time_in_millis":1655724129885,
	"duration_in_millis":200,
	"failures":[],
	"shards":{"total":1},
	}
	
**Приведите в ответе** список файлов в директории со `snapshot`ами:

	alex@testfin:~/myelastic$ sudo docker exec -it 7aead33f5d9d ls -la snapshots/
	total 32
	drwxr-xr-x 3 elastic elastic 4096 Jun 20 11:22 .
	drwxr-xr-x 1 elastic elastic 4096 Jun 20 11:07 ..
	-rw-r--r-- 1 elastic elastic  598 Jun 20 11:22 index-0
	-rw-r--r-- 1 elastic elastic    8 Jun 20 11:22 index.latest
	drwxr-xr-x 3 elastic elastic 4096 Jun 20 11:22 indices
	-rw-r--r-- 1 elastic elastic  202 Jun 20 11:22 meta-4zKz_xRbTo2YkM02zhOL0A.dat
	-rw-r--r-- 1 elastic elastic  352 Jun 20 11:22 snap-4zKz_xRbTo2YkM02zhOL0A.dat

Удалите индекс `test` и создайте индекс `test-2`:

	curl -X DELETE http://localhost:9200/test?pretty

	curl  -X PUT http://localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d
	'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}
	}'

**Приведите в ответе** список индексов:

	alex@testfin:~/myelastic$ curl -XGET 'localhost:9200/_cat/indices?v'
	health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
	green  open   test-2 obGRyvCdRVyKEEMNgti5SQ   1   0          0            0       225b           225b

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

	curl  -X POST http://localhost:9200/_snapshot/netology_backup/snapshot_elasticsearch/_restore?wait_for_completion=true 



	alex@testfin:~/myelastic$ curl  -X POST http://localhost:9200/_snapshot/netology_backup/snapshot_elasticsearch/_restore?wait_for_completion=true
	{
	"snapshot":{"snapshot":"snapshot_elasticsearch",
	"indices":["test"],
	"shards":{"total":1,"failed":0,"successful":1}}
	}


	alex@testfin:~/myelastic$ curl -XGET 'localhost:9200/_cat/indices?v'
	health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
	green  open   test-2 obGRyvCdRVyKEEMNgti5SQ   1   0          0            0       225b           225b
	green  open   test   vMtWpRovQPuSqimXyn3brw   1   0          0            0       225b           225b

</details> 


</details> 

## Домашнее задание к занятию 6.4.

<details><summary>Задачи</summary>

## Задача 1
	
<details><summary>Раскрой меня</summary>

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

</details> 
	
<details><summary>Ответ</summary>

	вывода списка БД  \l+
	подключения к БД \c {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
	вывода списка таблиц \dt[S+]
	вывода описания содержимого таблиц \d[S+]  tableNAME 
	выхода из psql \q

</details> 

## Задача 2
	
<details><summary>Раскрой меня</summary>
	
Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
	
</details> 
	
<details><summary>Ответ</summary>

	create database test_database;

	create user postgres WITH PASSWORD 'postgres';

	grant ALL ON DATABASE test_database TO postgres ;

	psql test_database < test.sql

	test_database=> ANALYZE VERBOSE orders;
	INFO:  analyzing "public.orders"
	INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows

	select avg_width from pg_stats where tablename='orders';

	test_database=> select avg_width from pg_stats where tablename='orders';
	 avg_width
	-----------
		 4
		16
		 4
	(3 rows)

</details> 
	
## Задача 3
	
<details><summary>Раскрой меня</summary>
	
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
											      
</details> 
	
<details><summary>Ответ</summary>

	первый подход : 
	begin;
	    alter table orders rename to orders_exp;
	    create table orders ( id integer NOT NULL, title varchar(80) NOT NULL, price integer) partition by range(price);
	    create table orders_1 partition of orders for values from (499) to (9999999);
	    create table orders_2 partition of orders for values from (0) to (499);
	    insert into orders (id, title, price) select * from orders_exp;
	    drop table orders_exp;
	commit;

	второй подход :

	begin;
	    create table orders_inh ( id integer NOT NULL, title varchar(80) NOT NULL, price integer);
	    create table orders_inh_1 ( check ( price > 499 )) INHERITS (orders_inh);
	    create table orders_inh_2 ( check ( price <= 499 )) INHERITS (orders_inh);
	    create rule insr_1 as on insert to orders_inh where ( price > 499 ) do instead insert into orders_inh_1 values (new.*);  	
	    create rule insr_2 as on insert to orders_inh where ( price <= 499 ) do instead insert into orders_inh_2 values (new.*); 
	    insert into orders_inh (id, title, price) select * from orders;
	commit;

	При изначальном проектировании таблиц можно было заложить такую возможность разбиения и выбрать подход (INHERITS или PARTITION).
								     
</details> 
	
## Задача 4
	
<details><summary>Раскрой меня</summary>
	
Используя утилиту `pg_dump` создайте бекап БД `test_database`.
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

</details> 
	
<details><summary>Ответ</summary>

	pg_dump -U postgres -d test_database > test_database_dump.sql
	
[бэкап БД](Https://github.com/Fintur8/devops-netology/blob/0b93ff14868a72091ff5e241c198015110c0f817/test_database_dump.sql)
	
Для уникальности можно добавить индекс.
	
	
</details> 
	
</details> 


## Домашнее задание к занятию 6.3.

<details><summary>Задачи</summary>
	
## Задача 1
	
<details><summary>Раскрой меня</summary>

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.
	
</details> 
	
<details><summary>Ответ</summary>
	
	docker-compose.yml
	version: '3'
	services:
	  db:
	    container_name: mysql_db
	    image: 'mysql:8'
	    restart: unless-stopped
	    ports:
	     - 3306:3306
	    environment:
		MYSQL_DATABASE: test_db
		MYSQL_ROOT_PASSWORD: test_db
		SERVICE_TAGS: dev
		SERVICE_NAME: mysql
	    volumes:
		- /home/alex/mysql/db_data/:/var/lib/mysql


	alex@testfin:~/mysql sudo docker-compose up -d

	alex@testfin:~/mysql sudo docker ps
	CONTAINER ID   IMAGE     COMMAND                  CREATED       STATUS       PORTS                                                  NAMES
	3ae231a01ae1   mysql:8   "docker-entrypoint.s…"   2 hours ago   Up 2 hours   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql_db

	alex@testfin:~/mysql sudo docker exec -it 3ae231a01ae1 bash
	
	Для восстановления создал файл бэкапа в который поместил содержимое исходного файла.
	
	alex@testfin:~/mysql mysql test_db -uroot -p  < backup_db.sql

	root@3ae231a01ae1:/# mysql test_db -uroot -p

	mysql> \s
	--------------
	mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

	Connection id:          15
	Current database:       test_db
	Current user:           root@localhost
	SSL:                    Not in use
	Current pager:          stdout
	Using outfile:          ''
	Using delimiter:        ;
	Server version:         8.0.29 MySQL Community Server - GPL
	Protocol version:       10
	Connection:             Localhost via UNIX socket
	Server characterset:    utf8mb4
	Db     characterset:    utf8mb4
	Client characterset:    latin1
	Conn.  characterset:    latin1
	UNIX socket:            /var/run/mysqld/mysqld.sock
	Binary data as:         Hexadecimal
	Uptime:                 1 hour 13 min 29 sec

	Threads: 2  Questions: 69  Slow queries: 0  Opens: 160  Flush tables: 3  Open tables: 78  Queries per second avg: 0.015
	--------------


	mysql> select * from orders;
	+----+-----------------------+-------+
	| id | title                 | price |
	+----+-----------------------+-------+
	|  1 | War and Peace         |   100 |
	|  2 | My little pony        |   500 |
	|  3 | Adventure mysql times |   300 |
	|  4 | Server gravity falls  |   300 |
	|  5 | Log gossips           |   123 |
	+----+-----------------------+-------+
	5 rows in set (0.00 sec)

	mysql>


	mysql> select * from orders where price>300;
	+----+----------------+-------+
	| id | title          | price |
	+----+----------------+-------+
	|  2 | My little pony |   500 |
	+----+----------------+-------+
	1 row in set (0.00 sec)

	mysql> select count(*) from orders where price>300;
	+----------+
	| count(*) |
	+----------+
	|        1 |
	+----------+
	1 row in set (0.00 sec)
	
</details>

## Задача 2
	
<details><summary>Раскрой меня</summary>	

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

</details> 
	
<details><summary>Ответ</summary>
	
	CREATE USER 'test' IDENTIFIED WITH mysql_native_password BY 'test-pass'
	 WITH MAX_QUERIES_PER_HOUR 100 
	 PASSWORD EXPIRE INTERVAL 180 DAY 
	 FAILED_LOGIN_ATTEMPTS 3
	 ATTRIBUTE '{"Surname": "Pretty", "Name": "James"}';

	GRANT SELECT ON test_db.* TO 'test';

	FLUSH PRIVILEGES;

	mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test'
	    -> ;
	+------+------+----------------------------------------+
	| USER | HOST | ATTRIBUTE                              |
	+------+------+----------------------------------------+
	| test | %    | {"Name": "James", "Surname": "Pretty"} |
	+------+------+----------------------------------------+
	1 row in set (0.00 sec)	
	
</details>	

## Задача 3
	
<details><summary>Раскрой меня</summary>	

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
	
</details> 
	
<details><summary>Ответ</summary>

	mysql> SET profiling = 1;
	Query OK, 0 rows affected, 1 warning (0.00 sec)

	У меня ничего не выводил полу включения , пришлось создать и удалить таблицу.

	mysql> CREATE TABLE test1 (id INT);

	mysql> DROP TABLE IF EXISTS test1;

	mysql> SHOW PROFILES;

	+----------+------------+-----------------------------+
	| Query_ID | Duration   | Query                       |
	+----------+------------+-----------------------------+
	|        1 | 0.00022300 | SET profiling = 1           |
	|        2 | 0.00022025 | SET profiling = 1           |
	|        3 | 0.31361200 | DROP TABLE IF EXISTS t1     |
	|        4 | 1.19806625 | CREATE TABLE T1 (id INT)    |
	|        5 | 0.00057900 | show engines                |
	|        6 | 0.30524475 | DROP TABLE IF EXISTS t1     |
	|        7 | 1.05834200 | CREATE TABLE test1 (id INT) |
	|        8 | 0.69094625 | DROP TABLE IF EXISTS test1  |
	+----------+------------+-----------------------------+
	8 rows in set, 1 warning (0.00 sec)

	Команда показывает все выполненные запросы за сессию с временем выполнения.
	На мой взгляд просто, удобно и можно узнать подробно на что тратилось время по каждому запросу.


	mysql> show engines;
	+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
	| Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
	+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
	| FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
	| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
	| InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
	| PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
	| MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
	| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
	| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
	| CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
	| ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
	+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
	9 rows in set (0.00 sec)


	mysql> SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test_db' ORDER BY ENGINE asc;
	+------------+--------+
	| TABLE_NAME | ENGINE |
	+------------+--------+
	| T1         | InnoDB |
	| orders     | InnoDB |
	+------------+--------+
	2 rows in set (0.00 sec)


	ALTER TABLE orders engine=MyISAM;

	16 | 1.48238000 | ALTER TABLE orders engine=MyISAM                                                                                                           

	15 rows in set, 1 warning (0.00 sec)

	mysql> SHOW PROFILE FOR QUERY 16;

	+--------------------------------+----------+
	| Status                         | Duration |
	+--------------------------------+----------+
	| starting                       | 0.000101 |
	| Executing hook on transaction  | 0.000012 |
	| starting                       | 0.000051 |
	| checking permissions           | 0.000014 |
	| checking permissions           | 0.000011 |
	| init                           | 0.000021 |
	| Opening tables                 | 0.000532 |
	| setup                          | 0.000211 |
	| creating table                 | 0.001985 |
	| waiting for handler commit     | 0.000018 |
	| waiting for handler commit     | 0.085639 |
	| After create                   | 0.000896 |
	| System lock                    | 0.000019 |
	| copy to tmp table              | 0.000199 |
	| waiting for handler commit     | 0.000024 |
	| waiting for handler commit     | 0.000023 |
	| waiting for handler commit     | 0.000061 |
	| rename result table            | 0.000154 |
	| waiting for handler commit     | 0.669057 |
	| waiting for handler commit     | 0.000047 |
	| waiting for handler commit     | 0.145316 |
	| waiting for handler commit     | 0.000020 |
	| waiting for handler commit     | 0.278835 |
	| waiting for handler commit     | 0.000021 |
	| waiting for handler commit     | 0.087258 |
	| end                            | 0.134762 |
	| query end                      | 0.076923 |
	| closing tables                 | 0.000022 |
	| waiting for handler commit     | 0.000042 |
	| freeing items                  | 0.000045 |
	| cleaning up                    | 0.000065 |
	+--------------------------------+----------+
	31 rows in set, 1 warning (0.01 sec)

	ALTER TABLE orders engine=InnoDB;

	17 | 1.40130450 | ALTER TABLE orders engine=InnoDB                                                                                                   
	15 rows in set, 1 warning (0.00 sec)

	mysql> SHOW PROFILE FOR QUERY 17;
	+--------------------------------+----------+
	| Status                         | Duration |
	+--------------------------------+----------+
	| starting                       | 0.000094 |
	| Executing hook on transaction  | 0.000009 |
	| starting                       | 0.000029 |
	| checking permissions           | 0.000010 |
	| checking permissions           | 0.000009 |
	| init                           | 0.000034 |
	| Opening tables                 | 0.000362 |
	| setup                          | 0.000094 |
	| creating table                 | 0.000158 |
	| After create                   | 0.407147 |
	| System lock                    | 0.000026 |
	| copy to tmp table              | 0.000209 |
	| rename result table            | 0.002119 |
	| waiting for handler commit     | 0.000019 |
	| waiting for handler commit     | 0.334613 |
	| waiting for handler commit     | 0.000020 |
	| waiting for handler commit     | 0.455778 |
	| waiting for handler commit     | 0.000022 |
	| waiting for handler commit     | 0.078955 |
	| waiting for handler commit     | 0.000020 |
	| waiting for handler commit     | 0.088075 |
	| end                            | 0.000944 |
	| query end                      | 0.032364 |
	| closing tables                 | 0.000023 |
	| waiting for handler commit     | 0.000053 |
	| freeing items                  | 0.000042 |
	| cleaning up                    | 0.000079 |
	+--------------------------------+----------+
	27 rows in set, 1 warning (0.00 sec)

</details>	

## Задача 4
	
<details><summary>Раскрой меня</summary>	

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

</details> 
	
<details><summary>Ответ</summary>

	[mysqld]
	pid-file        = /var/run/mysqld/mysqld.pid
	socket          = /var/run/mysqld/mysqld.sock
	datadir         = /var/lib/mysql
	secure-file-priv= NULL

	# Custom config should go here
	!includedir /etc/mysql/conf.d/
	default-storage-engine          =InnoDB
	innodb_buffer_pool_size         =5734M
	innodb_log_file_size            =100M
	innodb_log_buffer_size          =1M
	innodb_file_per_table           =enable
	innodb_flush_method             =O_DIRECT
	innodb_flush_log_at_trx_commit  =2
	query_cache_size                =0

</details>	
	
</details>

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
