# Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?

**Ответ:**
оперативная память 1024мб
2 процессора
диск 64 гб
сетевой адаптер
# Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
**Ответ:**
Необходимо раскоментировать строчку config.vm.provider "virtualbox" do |v| и добавить необходимое количестов ресурсов коммандами   v.memory = 1024    v.cpus = 2
# какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
**Ответ:**
HISTFILESIZE  на 698 строчке и HISTSIZE на 709
**Ответ:**
# что делает директива ignoreboth в bash?
**Ответ:**
ignoreboth это сокращение для  директив ignorespace and ignoredups
# В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
**Ответ:**
скобки {} применимы в : RESERVED WORDS(152 строка), Lists (191 строка)
# С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?
**Ответ:**
touch {000001..100000} , не получится. пробовал вводить, остановился на 109999
# В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
**Ответ:**
условие у [[ -d /tmp ]] проверяет  наличие катаолга /tmp
# Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
**Ответ:**
mkdir /tmp/new_path_dir/
cp /bin/bash /tmp/new_path_dir/
PATH=/tmp/new_path_dir/:$PATH
type -a bash

Чем отличается планирование команд с помощью batch и at?
batch или его псевдоним at -b планирует задания и выполняет их в пакетной очереди.
at — позволяет нам планировать выполнение команд в определенное время. 

