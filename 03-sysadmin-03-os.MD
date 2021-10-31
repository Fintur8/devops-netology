# 1. Какой системный вызов делает команда cd?

ioctl(2, TIOCGPGRP, [5097])             = 0

rt_sigaction(SIGCHLD, {sa_handler=0x561ce89ffaa0, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f1c0a37e210}, {sa_handler=SIG_DFL, sa_mask=[]

sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f1c0a37e210}, 8) = 0

prlimit64(0, RLIMIT_NPROC, NULL, {rlim_cur=3707, rlim_max=3707}) = 0

rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0

rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0

stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0

chdir("/tmp")                           = 0

rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0

rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0

exit_group(0)                           = ?

+++ exited with 0 +++


# 2.Попробуйте использовать команду file на объекты разных типов на файловой системе. Например: 

комманда файл использует БД "магических последовательностей байтов"

openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3

openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3

# 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

Можно воспользоваться коммандой 

lsof | grep deleted для определения удаленного файла, а далее есть 2 варианта :

1) передать процессу  комманду echo '' > /proc/PID процесса /fd/ номер дескриптора

2)  вопользоваться коммандой cat /dev/null > file

в обоих случаях размер сбросится .

# 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
Зомби - это фантомный процесс, который просто имеет запись в таблице процессов, но при этом никакие ресурсы кроме пространства таблицы процессов, не используются. 

Запись >свободиться при вызове wait() родительским процессом.

# 5. В iovisor BCC есть утилита opensnoop
vagrant@vagrant:~$ sudo opensnoop-bpfcc

PID    COMM               FD ERR PATH  

605    irqbalance          6   0 /proc/interrupts

605    irqbalance          6   0 /proc/stat

605    irqbalance          6   0 /proc/irq/20/smp_affinity

605    irqbalance          6   0 /proc/irq/0/smp_affinity

605    irqbalance          6   0 /proc/irq/1/smp_affinity

605    irqbalance          6   0 /proc/irq/8/smp_affinity

605    irqbalance          6   0 /proc/irq/12/smp_affinity

605    irqbalance          6   0 /proc/irq/14/smp_affinity

605    irqbalance          6   0 /proc/irq/15/smp_affinity

785    vminfo              4   0 /var/run/utmp

# 6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

uname -a использует системный вызов uname(2)

цитата :

Part of the utsname information is also accessible via

/proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

>vagrant@vagrant:~$ sudo ls /proc/sys/kernel/
>Display all 120 possibilities? (y or n)
>acct                                 max_lock_depth                       perf_event_mlock_kb                  seccomp/
>acpi_video_flags                     modprobe                             perf_event_paranoid                  sem
>auto_msgmni                          modules_disabled                     pid_max                              sem_next_id
>bootloader_type                      msg_next_id                          poweroff_cmd                         sg-big-buff
>bootloader_version                   msgmax                               print-fatal-signals                  shm_next_id
>bpf_stats_enabled                    msgmnb                               printk                               shm_rmid_forced
>cad_pid                              msgmni                               printk_delay                         shmall
>cap_last_cap                         ngroups_max                          printk_devkmsg                       shmmax
>core_pattern                         nmi_watchdog                         printk_ratelimit                     shmmni
>core_pipe_limit                      ns_last_pid                          printk_ratelimit_burst               soft_watchdog
>core_uses_pid                        numa_balancing                       pty/                                 softlockup_all_cpu_backtrace
>ctrl-alt-del                         numa_balancing_scan_delay_ms         random/                              softlockup_panic
>dmesg_restrict                       numa_balancing_scan_period_max_ms    randomize_va_space                   stack_tracer_enabled
>domainname                           numa_balancing_scan_period_min_ms    real-root-dev                        sysctl_writes_strict
>firmware_config/                     numa_balancing_scan_size_mb          sched_autogroup_enabled              sysrq
>ftrace_dump_on_oops                  osrelease                            sched_cfs_bandwidth_slice_us         tainted
>ftrace_enabled                       ostype                               sched_child_runs_first               threads-max
>hardlockup_all_cpu_backtrace         overflowgid                          sched_domain/                        timer_migration
>hardlockup_panic                     overflowuid                          sched_latency_ns                     traceoff_on_warning
>hostname                             panic                                sched_migration_cost_ns              tracepoint_printk
>hotplug                              panic_on_io_nmi                      sched_min_granularity_ns             unknown_nmi_panic
>hung_task_check_count                panic_on_oops                        sched_nr_migrate                     unprivileged_bpf_disabled
>hung_task_check_interval_secs        panic_on_rcu_stall                   sched_rr_timeslice_ms                unprivileged_userns_apparmor_policy
>hung_task_panic                      panic_on_unrecovered_nmi             sched_rt_period_us                   unprivileged_userns_clone
>hung_task_timeout_secs               panic_on_warn                        sched_rt_runtime_us                  usermodehelper/
>hung_task_warnings                   panic_print                          sched_schedstats                     version
>io_delay_type                        perf_cpu_time_max_percent            sched_tunable_scaling                watchdog
>kexec_load_disabled                  perf_event_max_contexts_per_stack    sched_util_clamp_max                 watchdog_cpumask
>keys/                                perf_event_max_sample_rate           sched_util_clamp_min                 watchdog_thresh
>kptr_restrict                        perf_event_max_stack                 sched_wakeup_granularity_ns          yama/

# 7.Чем отличается последовательность команд через ; и через && в bash? Есть ли смысл использовать в bash &&, если применить set -e?

Оператор точка с запятой позволяет запускать несколько команд за один раз, и выполнение команды происходит последовательно.

Оператор AND (&&) будет выполнять вторую команду только в том случае, если при выполнении первой команды состояние выхода равно 0. 

В нашем случае при выполнении "test -d /tmp/some_dir; echo Hi"  отобразится "Hi"  так как команды выполнялются последоватильно и не зависят друг от друга.

А при выполнении "test -d /tmp/some_dir && echo Hi" вывод "Hi" будет зависеть от результата выполнения комманды "test -d /tmp/some_dir" и если  test вернет 0, то команда echo 

выведет на экран "Hi"

# 8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?

bash set -euxo pipefail состоит из: 

 -e указывает оболочке выйти, если команда дает ненулевой статус выхода. Проще говоря, оболочка завершает работу при сбое команды.
 
 -u обрабатывает неустановленные или неопределенные переменные, за исключением специальных параметров, таких как подстановочные знаки (*) или «@», как ошибки во время раскрытия параметра.
 
 -x печатает аргументы команды во время выполнения

-o pipefail - прекращает выполнение скрипта, даже если одна из частей пайпа завершилась ошибкой


Для сценария , улучшает детализацию вывода ошибок, и прекратит выполнение сценария при наличии ошибок, на любом этапе выполнения, кроме последней завершающей команды.

# 9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

Наиболее часто встречающийся статус у процессов в систем это Ss(состояние прерывистого сона (в ожидании завершения события) и R+(работает или запускается (в очереди выполнения) и находится в группе процессов на переднем плане)








