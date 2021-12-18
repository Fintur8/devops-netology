# 1. Работа c HTTP через телнет.  
Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80  
отправьте HTTP запрос   
GET /questions HTTP/1.0  
HOST: stackoverflow.com  
[press enter]  
[press enter]  
В ответе укажите полученный HTTP код, что он означает?  

vagrant@vagrant:~$ telnet stackoverflow.com 80  
Trying 151.101.1.69...  
Connected to stackoverflow.com.  
Escape character is '^]'.  
 

GET /questions HTTP/1.0   
HOST: stackoverflow.com   

HTTP/1.1 301 Moved Permanently   
cache-control: no-cache, no-store, must-revalidate  
location: https://stackoverflow.com/questions  
x-request-guid: bb79f3ad-daa2-4b77-a099-30437ad3d466  
feature-policy: microphone 'none'; speaker 'none'  
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com  
Accept-Ranges: bytes  
Date: Sat, 18 Dec 2021 13:26:36 GMT   
Via: 1.1 varnish   
Connection: close  
X-Served-By: cache-hel1410032-HEL  
X-Cache: MISS  
X-Cache-Hits: 0  
X-Timer: S1639833996.193101,VS0,VE109  
Vary: Fastly-SSL  
X-DNS-Prefetch-Control: off  
Set-Cookie: prov=d1f379e2-25b5-dd9c-681c-01aef7fc20cd; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly  

При подключении произошел редирект на страницу с нашим запросом и вывелись параметры страницы.  


# 2.Повторите задание 1 в браузере, используя консоль разработчика F12.

Request URL: https://stackoverflow.com/  
Request Method: GET  
Status Code: 200   
Remote Address: 151.101.129.69:443  
Referrer Policy: no-referrer-when-downgrade  
accept-ranges: bytes  
cache-control: private  
content-encoding: gzip  
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com  
content-type: text/html; charset=utf-8  
date: Sat, 18 Dec 2021 13:47:22 GMT  
feature-policy: microphone 'none'; speaker 'none'  
strict-transport-security: max-age=15552000  
vary: Accept-Encoding,Fastly-SSL  
via: 1.1 varnish  
x-cache: MISS  
x-cache-hits: 0  
x-dns-prefetch-control: off  
x-frame-options: SAMEORIGIN   
x-request-guid: 7e548163-88c3-4cac-8f96-cfc00849390a  
x-served-by: cache-hel1410032-HEL  
x-timer: S1639835242.367698,VS0,VE113  
:authority: stackoverflow.com  
:method: GET  
:path: /  
:scheme: https  
accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9  
accept-encoding: gzip, deflate, br  
accept-language: ru,en;q=0.9  
cache-control: max-age=0  
cookie: prov=91b832cd-c98f-6406-2fdb-09d895a2d55b; _ym_uid=1611081469991406703; _ga=GA1.2.1920115969.1611081469; __qca=P0-1008472435-1611081469280; __gads=ID=ae71bce67662ada9-22185986a4ba0011:T=1614662111:S=ALNI_MbMKR-gWJpwXDVF5jnLLWAEB6X5BQ; OptanonAlertBoxClosed=2021-10-03T20:52:37.808Z; OptanonConsent=isIABGlobal=false&datestamp=Mon+Oct+04+2021+00%3A52%3A37+GMT%2B0400+(%D0%9F%D0%B5%D1%80%D1%81%D0%B8%D0%B4%D1%81%D0%BA%D0%B8%D0%B9+%D0%B7%D0%B0%D0%BB%D0%B8%D0%B2)&version=6.10.0&hosts=&landingPath=NotLandingPage&groups=C0003%3A1%2CC0004%3A1%2CC0002%3A1%2CC0001%3A1; _ym_d=1634497458; mfnes=21c9CA4QAxoLCNaoqsuyhaA6EAUgBSgBMghhZjkyY2U3Nw==; _gid=GA1.2.285523852.1639834945; _gat=1  
dnt: 1  
sec-fetch-dest: document  
sec-fetch-mode: navigate  
sec-fetch-site: cross-site 
sec-fetch-user: ?1  
upgrade-insecure-requests: 1  
user-agent: Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1  


# 3. Какой у Вас ip адресс

Мой IP: 109.195.21.216  


# 4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois

Ну судя по выводу комманды "whois -h whois.ripe.net  109.195.21.216"  провайдер: CJSC "Company "ER-Telecom" Saratov ( TM DOM.RU, Saratov ISP ), AS50543  
 
vagrant@vagrant:~$ whois -h whois.ripe.net  109.195.21.216  
% This is the RIPE Database query service.  
% The objects are in RPSL format.  
%
% The RIPE Database is subject to Terms and Conditions.  
% See http://www.ripe.net/db/support/db-terms-conditions.pdf  

% Note: this output has been filtered.  
%       To receive output for a database update, use the "-B" flag.  

% Information related to '109.195.16.0 - 109.195.23.255'  
 
% Abuse contact for '109.195.16.0 - 109.195.23.255' is 'abuse@domru.ru'  

inetnum:        109.195.16.0 - 109.195.23.255  
netname:        ERTH-SARATOV-MAIN-NET  
descr:          CJSC "Company "ER-Telecom" Saratov  
descr:          Saratov, Russia  
descr:          Main network  
country:        RU  
admin-c:        ERTH64-RIPE  
org:            ORG-CHSB1-RIPE  
tech-c:         ERTH64-RIPE  
status:         ASSIGNED PA  
mnt-by:         RAID-MNT  
remarks:        INFRA-AW  
created:        2010-01-29T13:07:30Z  
last-modified:  2011-01-19T19:02:18Z  
source:         RIPE # Filtered  

organisation:   ORG-CHSB1-RIPE  
org-name:       JSC "ER-Telecom Holding" Saratov Branch  
org-type:       OTHER  
descr:          TM DOM.RU, Saratov ISP  
address:        Slonova I.A. str., 1  
address:        410000 Saratov  
address:        Russian Federation  
phone:          +7 8452 338-999  
fax-no:         +7 8452 338-999  
abuse-c:        RAID1-RIPE  
admin-c:        ERTH64-RIPE 
tech-c:         ERTH64-RIPE  
mnt-ref:        RAID-MNT  
mnt-by:         RAID-MNT  
created:        2009-12-24T10:29:39Z  
last-modified:  2019-10-15T08:11:57Z  
source:         RIPE # Filtered  

role:           Network Operation Center CJSC ER-Telecom Holding Saratov branch  
address:        CJSC "ER-Telecom Holding" Saratov branch  
address:        Slonova I.A. str., 1  
address:        410000 Saratov  
address:        Russian Federation  
phone:          +7 8452 338-999  
fax-no:         +7 8452 338-999  
abuse-mailbox:  abuse@domru.ru  
admin-c:        RAID1-RIPE  
tech-c:         RAID1-RIPE  
nic-hdl:        ERTH64-RIPE  
created:        2009-12-24T10:16:38Z  
last-modified:  2019-11-06T05:18:35Z  
source:         RIPE # Filtered  
mnt-by:         RAID-MNT  

% Information related to '109.195.21.0/24AS50543'  

route:          109.195.21.0/24  
origin:         AS50543  
org:            ORG-CHSB1-RIPE  
descr:          CJSC "ER-Telecom Holding" Saratov branch  
descr:          Saratov, Russia  
mnt-by:         RAID-MNT  
created:        2010-08-17T10:37:54Z  
last-modified:  2013-04-25T10:26:16Z  
source:         RIPE  

organisation:   ORG-CHSB1-RIPE  
org-name:       JSC "ER-Telecom Holding" Saratov Branch  
org-type:       OTHER  
descr:          TM DOM.RU, Saratov ISP  
address:        Slonova I.A. str., 1  
address:        410000 Saratov  
address:        Russian Federation  
phone:          +7 8452 338-999  
fax-no:         +7 8452 338-999  
abuse-c:        RAID1-RIPE  
admin-c:        ERTH64-RIPE  
tech-c:         ERTH64-RIPE  
mnt-ref:        RAID-MNT  
mnt-by:         RAID-MNT  
created:        2009-12-24T10:29:39Z  
last-modified:  2019-10-15T08:11:57Z  
source:         RIPE # Filtered  

% This query was served by the RIPE Database Query Service version 1.102.1 (ANGUS)  

# 5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute

vagrant@vagrant:~$ traceroute -IAn 8.8.8.8  
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets  
 1  10.0.2.2 [*]  0.462 ms  0.429 ms  0.422 ms  
 2  192.168.1.1 [*]  2.444 ms  2.438 ms  2.431 ms  
 3  188.232.3.253 [AS50543]  2.864 ms  2.857 ms  2.849 ms  
 4  109.195.24.30 [AS50543]  2.834 ms  2.825 ms  2.803 ms  
 5  72.14.215.165 [AS15169]  17.795 ms  18.003 ms  17.960 ms  
 6  72.14.215.166 [AS15169]  18.771 ms  18.417 ms  18.630 ms  
 7  108.170.250.129 [AS15169]  18.587 ms  17.887 ms  18.031 ms  
 8  108.170.250.130 [AS15169]  33.072 ms  33.058 ms  33.032 ms   
 9  209.85.255.136 [AS15169]  33.734 ms  33.918 ms  33.706 ms  
10  108.170.235.64 [AS15169]  32.445 ms  32.691 ms  32.392 ms  
11  216.239.57.5 [AS15169]  32.120 ms  32.313 ms  31.773 ms  
12  * * *  
13  * * *  
14  * * *  
15  * * *  
16  * * *  
17  * * *  
18  * * *  
19  * * *  
20  * * *  
21  8.8.8.8 [AS15169]  33.015 ms  33.002 ms  32.768 ms  


# 6 Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?  
AS15169  209.85.255.136         0.0%    39   31.9  33.7  31.4  73.0   6.6  

# 7.Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig   

vagrant@vagrant:~$ dig dns.google.com  

; <<>> DiG 9.16.1-Ubuntu <<>> dns.google.com  
;; global options: +cmd  
;; Got answer:  
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 10386  
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1  

;; OPT PSEUDOSECTION:  
; EDNS: version: 0, flags:; udp: 65494  
;; QUESTION SECTION:  
;dns.google.com.                        IN      A  

;; ANSWER SECTION:
dns.google.com.         740     IN      A       8.8.4.4  
dns.google.com.         740     IN      A       8.8.8.8  

;; Query time: 3 msec  
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Sat Dec 18 20:01:54 UTC 2021 
;; MSG SIZE  rcvd: 75  



# 8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig  

vagrant@vagrant:~$ dig -x 8.8.8.8  
 
; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8  
;; global options: +cmd  
;; Got answer:  
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 62637  
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1  

;; OPT PSEUDOSECTION:  
; EDNS: version: 0, flags:; udp: 65494  
;; QUESTION SECTION:  
;8.8.8.8.in-addr.arpa.          IN      PTR  

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   5088    IN      PTR     dns.google.  

;; Query time: 0 msec  
;; SERVER: 127.0.0.53#53(127.0.0.53)  
;; WHEN: Sat Dec 18 20:10:14 UTC 2021  
;; MSG SIZE  rcvd: 73  

vagrant@vagrant:~$ dig -x 8.8.4.4  

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4  
;; global options: +cmd  
;; Got answer:  
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 8841  
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1  

;; OPT PSEUDOSECTION:  
; EDNS: version: 0, flags:; udp: 65494  
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.          IN      PTR  

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.   65726   IN      PTR     dns.google.  

;; Query time: 3 msec  
;; SERVER: 127.0.0.53#53(127.0.0.53)  
;; WHEN: Sat Dec 18 20:10:51 UTC 2021  
;; MSG SIZE  rcvd: 73  

vagrant@vagrant:~$  











