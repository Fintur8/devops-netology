# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис
  
  Добавил запятую в 6 строку, добавил недостающие кавычки в строке 9  
  --
```
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name": "first",
        "type": "server",
        "ip": 7175 
        },
        { "name":"second",
        "type": "proxy",
        "ip": "71.78.22.43"
        }
    ]
}
```
## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
import os
import socket as s
import json
import yaml

json_data = 'ip.json'
yaml_data = 'ip.yaml'

if not os.path.exists(json_data) or not os.path.exists(yaml_data):
    data = {}
    data['srv'] = []
    srv_list = ['drive.google.com',
                'mail.google.com', 'google.com', 'ya.ru']
    for srv_dns in srv_list:
        data['srv'].append({
            srv_dns: s.gethostbyname(srv_dns)
        })
    with open(json_data, 'w') as outfile:
        json.dump(data, outfile)
    with open(yaml_data, 'w') as file:
        yaml.dump(data, file)
with open(json_data) as json_file:
    data = json.load(json_file)

write_new_data = False
for server in data['srv']:
    for data_dns in server:
        data_ip = server[data_dns]
        curr_ip = s.gethostbyname(data_dns)
        print(f'{data_dns} - {curr_ip}')
        if curr_ip != data_ip:
            print(
                f'[ERROR] {data_dns} IP mismatch: old {data_ip} new {curr_ip}')
            write_new_data = True
            server[data_dns] = curr_ip

if write_new_data:
    with open(json_data, 'w') as outfile:
        json.dump(data, outfile)
    with open(yaml_data, 'w') as file:
        yaml.dump(data, file)
```

### Вывод скрипта при запуске при тестировании:
```
drive.google.com - 64.233.165.194
mail.google.com - 108.177.14.17
[ERROR] mail.google.com IP mismatch: old 108.177.14.19 new 108.177.14.17
google.com - 108.177.14.100
[ERROR] google.com IP mismatch: old 108.177.14.138 new 108.177.14.100
ya.ru - 87.250.250.242
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"srv": [{"drive.google.com": "64.233.165.194"}, {"mail.google.com": "108.177.14.17"}, {"google.com": "108.177.14.100"}, {"ya.ru": "87.250.250.242"}]}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
srv:
- drive.google.com: 64.233.165.194
- mail.google.com: 108.177.14.17
- google.com: 108.177.14.100
- ya.ru: 87.250.250.242
```
