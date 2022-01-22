# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Значение C присвоено не будет, так как Python выдаст ошибку о несовместимости операции сложения двух разных типов переменных. |
| Как получить для переменной `c` значение 12?  | Необходимо выполнить преобразование переменной "a" в тип "str"  |
| Как получить для переменной `c` значение 3?  | Необходимо выполнить преобразование переменной "b" в тип "int"  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3
    import os
    from os.path import expanduser
    dir= expanduser("~")
    bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    print('Files are modifided:')
    for result in result_os.split('\n'):
            if result.find('modified') != -1:
                  prepare_result = result.replace('\tmodified:','')
                  print(f'{dir}//netology/sysadm-homeworks/{prepare_result}')
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@node1:~$ /home/vagrant/netology/sysadm-homeworks/python.py
    Files are modifided:
    /home/vagrant/netology/sysadm-homeworks/   1.py
    /home/vagrant/netology/sysadm-homeworks/   python.py
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3
    import os
    import sys
    import subprocess
    dir = sys.argv[1]
    bash_command = ["cd " + dir, "git status"]
    os.chdir(dir)
    with subprocess.Popen(['git', 'status'], stdout=subprocess.PIPE) as proc:
        result = proc.stdout.read().decode("utf-8")
    if result.find('not') == -1:
        print('Тут нет репозитория!')
    else:
      result_os =  os.popen(' && '.join(bash_command)).read()
      print('Files are modifided:')
    for result in result_os.split('\n'):
          if result.find('modified') != -1:
              prepare_result = result.replace('\tmodified:   ', '')
              print(f'{dir}{prepare_result}')
```

### Вывод скрипта при запуске при тестировании:
```
 vagrant@node1:~$ /home/vagrant/netology/sysadm-homeworks/python2.py /home/vagrant/netology/sysadm-homeworks/
    Files are modifided:
    /home/vagrant/netology/sysadm-homeworks/1.py
    /home/vagrant/netology/sysadm-homeworks/python.py

    vagrant@node1:~$ /home/vagrant/netology/sysadm-homeworks/python2.py /home/
    fatal: not a git repository (or any of the parent directories): .git
    Тут нет репозитория!
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
 #!/usr/bin/env python3
    import socket as s
    import time as t
    import datetime as dtm

    i = 1
    wait = 2
    srv = {'drive.google.com': '192.168.1.17', 'mail.google.com': '192.168.1.1', 'google.com': '192.168.1.47'}
    init = 0

    print(srv)
    while 1 == 1:
        for host in srv:
            ip = s.gethostbyname(host)
            if ip != srv[host]:
                if i == 1 and init != 1:
                    print(str(dtm.datetime.now().strftime("%H:%M:%S %d-%m-%Y")) +' [ERROR] ' + str(host) + ' IP mistmatch: '+srv[host]+' '+ip)
            srv[host] = ip
        i += 1
        if i >= 10:
            break
```

### Вывод скрипта при запуске при тестировании:
```
{'drive.google.com': '192.168.1.17', 'mail.google.com': '192.168.1.1', 'google.com': '192.168.1.47'}
    23:17:09 16-01-2022 [ERROR] drive.google.com IP mistmatch: 192.168.1.17 173.194.73.194
    23:17:09 16-01-2022 [ERROR] mail.google.com IP mistmatch: 192.168.1.1 74.125.205.83
    23:17:09 16-01-2022 [ERROR] google.com IP mistmatch: 192.168.1.47 74.125.205.101
```
