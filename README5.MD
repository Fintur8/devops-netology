# 1) Создайте виртуальную машину Linux.  
c:\vagrant>vagrant up node1   
-
    Bringing machine 'node1' up with 'virtualbox' provider...  
    ==> node1: Importing base box 'bento/ubuntu-20.04'...  
    ==> node1: Matching MAC address for NAT networking...  
    ==> node1: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...  
    ==> node1: Setting the name of the VM: vagrant_node1_1641495059120_30767  
    ==> node1: Clearing any previously set network interfaces...  
    ==> node1: Preparing network interfaces based on configuration...  
    node1: Adapter 1: nat  
    node1: Adapter 2: bridged  
    ==> node1: Forwarding ports...  
    node1: 80 (guest) => 8080 (host) (adapter 1)  
    node1: 443 (guest) => 4430 (host) (adapter 1)  
    node1: 22 (guest) => 2222 (host) (adapter 1)  
    ==> node1: Running 'pre-boot' VM customizations...  
    ==> node1: Booting VM...  
    ==> node1: Waiting for machine to boot. This may take a few minutes...  
    node1: SSH address: 127.0.0.1:2222  
    node1: SSH username: vagrant  
    node1: SSH auth method: private key  
    node1:  
    node1: Vagrant insecure key detected. Vagrant will automatically replace  
    node1: this with a newly generated keypair for better security.  
    node1:  
    node1: Inserting generated public key within guest...  
    node1: Removing insecure key from the guest if it's present...  
    node1: Key inserted! Disconnecting and reconnecting using new SSH key...  
    ==> node1: Machine booted and ready!  
    ==> node1: Checking for guest additions in VM...  
    ==> node1: Setting hostname...  
    ==> node1: Configuring and enabling network interfaces...  
    ==> node1: Mounting shared folders...  
    node1: /vagrant => C:/vagrant  

vagrant@node1:~$ sudo apt install jq   
-
    Reading package lists... Done  
    Building dependency tree  
    Reading state information... Done  
    The following additional packages will be installed:  
     libjq1 libonig5  
    The following NEW packages will be installed:  
    jq libjq1 libonig5  
    0 upgraded, 3 newly installed, 0 to remove and 5 not upgraded.  
    Need to get 313 kB of archives.  
    After this operation, 1,062 kB of additional disk space will be used.  
    Do you want to continue? [Y/n] y  
    Get:1 http://archive.ubuntu.com/ubuntu focal/universe amd64 libonig5 amd64 6.9.4-1 [142 kB]  
    Get:2 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 libjq1 amd64 1.6-1ubuntu0.20.04.1 [121 kB]  
    Get:3 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 jq amd64 1.6-1ubuntu0.20.04.1 [50.2   
    Fetched 313 kB in 1s (501 kB/s)  
    Selecting previously unselected package libonig5:amd64.  
    (Reading database ... 41707 files and directories currently installed.)  
    Preparing to unpack .../libonig5_6.9.4-1_amd64.deb ...  
    Unpacking libonig5:amd64 (6.9.4-1) ...  
    Selecting previously unselected package libjq1:amd64.  
    Preparing to unpack .../libjq1_1.6-1ubuntu0.20.04.1_amd64.deb ...  
    Unpacking libjq1:amd64 (1.6-1ubuntu0.20.04.1) ...  
    Selecting previously unselected package jq.  
    Preparing to unpack .../jq_1.6-1ubuntu0.20.04.1_amd64.deb ...  
    Unpacking jq (1.6-1ubuntu0.20.04.1)   
    Setting up libonig5:amd64 (6.9.4-1) ...  
    Setting up libjq1:amd64 (1.6-1ubuntu0.20.04.1) ...  
    Setting up jq (1.6-1ubuntu0.20.04.1) ...  
    Processing triggers for man-db (2.9.1-1) ...  

vagrant@node1:~$ sudo apt install chrony
-
vagrant@node1:~$ sudo timedatectl set-timezone Europe/Saratov  
-
vagrant@node1:~$  sudo nano /etc/hosts  
-
    192.168.1.17 vault.vagrant.local
    192.168.1.17 nginx.vagrant.local

# 2) Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.  

vagrant@node1:~$ sudo ufw status  
-
    Status: inactive 

vagrant@node1:~$ sudo ufw allow ssh  
-
vagrant@node1:~$ sudo ufw allow https  
-
vagrant@node1:~$ sudo ufw allow in on lo  
-
vagrant@node1:~$ sudo ufw allow out on lo  
-
vagrant@node1:~$ sudo ufw allow 8200
-
vagrant@node1:~$ sudo ufw enable  
-
    Command may disrupt existing ssh connections. Proceed with operation (y|n)? y  
    Firewall is active and enabled on system startup  
vagrant@node1:~$ sudo ufw status
-
    Status: active
    To                         Action      From  
    --                         ------      ----  
    22/tcp                     ALLOW       Anywhere  
    443/tcp                    ALLOW       Anywhere   
    Anywhere on lo             ALLOW       Anywhere  
    8200                       ALLOW       Anywhere  
    22/tcp (v6)                ALLOW       Anywhere (v6)  
    443/tcp (v6)               ALLOW       Anywhere (v6)  
    Anywhere (v6) on lo        ALLOW       Anywhere (v6)  
    8200 (v6)                  ALLOW       Anywhere (v6)  
    Anywhere                   ALLOW OUT   Anywhere on lo  
    Anywhere (v6)              ALLOW OUT   Anywhere (v6) on lo  

# 3) Установите hashicorp vault (инструкция по ссылке).  

vagrant@node1:~$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -  
-
    OK  

vagrant@node1:~$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"   
-
    Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease  
    Get:2 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]  
    Get:3 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]  
    Get:4 https://apt.releases.hashicorp.com focal InRelease [9,495 B]   
    Hit:5 http://archive.ubuntu.com/ubuntu focal-backports InRelease  
    Get:6 https://apt.releases.hashicorp.com focal/main amd64 Packages [41.1 kB]  
    Get:7 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1,438 kB]  
    Get:8 http://security.ubuntu.com/ubuntu focal-security/main i386 Packages [351 kB]  
    Get:9 http://archive.ubuntu.com/ubuntu focal-updates/main i386 Packages [580 kB]  
    Get:10 http://archive.ubuntu.com/ubuntu focal-updates/main Translation-en [288 kB]  
    Get:11 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [656 kB]  
    Get:12 http://archive.ubuntu.com/ubuntu focal-updates/restricted i386 Packages [21.8 kB]  
    Get:13 http://archive.ubuntu.com/ubuntu focal-updates/restricted Translation-en [93.6 kB]  
    Get:14 http://archive.ubuntu.com/ubuntu focal-updates/universe i386 Packages [655 kB]  
    Get:15 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [885 kB]  
    Get:16 http://archive.ubuntu.com/ubuntu focal-updates/universe Translation-en [193 kB]  
    Get:17 http://archive.ubuntu.com/ubuntu focal-updates/multiverse i386 Packages [8,432 B]  
    Get:18 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [24.8 kB]  
    Get:19 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [1,106 kB]  
    Get:20 http://security.ubuntu.com/ubuntu focal-security/main Translation-en [201 kB]  
    Get:21 http://security.ubuntu.com/ubuntu focal-security/restricted i386 Packages [20.5 kB]  
    Get:22 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [606 kB]  
    Get:23 http://security.ubuntu.com/ubuntu focal-security/restricted Translation-en [86.3 kB]  
    Get:24 http://security.ubuntu.com/ubuntu focal-security/universe i386 Packages [524 kB]  
    Get:25 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [668 kB]  
    Get:26 http://security.ubuntu.com/ubuntu focal-security/multiverse i386 Packages [7,176 B]  
    Get:27 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [21.8 kB]  
    Fetched 8,715 kB in 10s (910 kB/s)  
    Reading package lists... Done  

vagrant@node1:~$ sudo apt-get update && sudo apt-get install vault  
-
    Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease  
    Hit:2 http://archive.ubuntu.com/ubuntu focal-updates InRelease  
    Hit:3 http://archive.ubuntu.com/ubuntu focal-backports InRelease  
    Hit:4 https://apt.releases.hashicorp.com focal InRelease  
    Hit:5 http://security.ubuntu.com/ubuntu focal-security InRelease  
    Reading package lists... Done  
    Reading package lists... Done  
    Building dependency tree  
    Reading state information... Done  
    The following NEW packages will be installed:  
      vault  
    0 upgraded, 1 newly installed, 0 to remove and 11 not upgraded.  
    Need to get 69.4 MB of archives.  
    After this operation, 188 MB of additional disk space will be used.  
    Get:1 https://apt.releases.hashicorp.com focal/main amd64 vault amd64 1.9.2 [69.4 MB]  
    Fetched 69.4 MB in 7s (9,699 kB/s)  
    Selecting previously unselected package vault.  
    (Reading database ... 48324 files and directories currently installed.)  
    Preparing to unpack .../archives/vault_1.9.2_amd64.deb ...  
    Unpacking vault (1.9.2) ...  
    Setting up vault (1.9.2) ...  
    Generating Vault TLS key and self-signed certificate...  
    Generating a RSA private key  
    ...........................................++++  
    ............................................................++++  
    writing new private key to 'tls.key'  
    -----
    Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.  

vagrant@node1:~$ vault  
-
    Usage: vault <command> [args]  

    Common commands:  
        read        Read data and retrieves secrets  
        write       Write data, configuration, and secrets  
        delete      Delete secrets and configuration  
        list        List data or secrets  
        login       Authenticate locally  
        agent       Start a Vault agent  
        server      Start a Vault server  
        status      Print seal and HA status  
        unwrap      Unwrap a wrapped secret  

    Other commands:  
        audit          Interact with audit devices  
        auth           Interact with auth methods  
        debug          Runs the debug command  
        kv             Interact with Vault's Key-Value storage  
        lease          Interact with leases  
        monitor        Stream log messages from a Vault server  
        namespace      Interact with namespaces  
        operator       Perform operator-specific tasks  
        path-help      Retrieve API help for paths  
        plugin         Interact with Vault plugins and catalog  
        policy         Interact with policies  
        print          Prints runtime configurations  
        secrets        Interact with secrets engines  
        ssh            Initiate an SSH session  
        token          Interact with tokens  

vagrant@node1:~$ sudo mkdir -p ./vault/data  
-
vagrant@node1:~$ sudo nano /etc/vault.d/vault.hcl  
-
    disable_cache = true  
    disable_mlock = true  
    ui = true  

    listener "tcp" {  
        tls_disable      = "true"  
    #address          = "0.0.0.0:8200"  
        address          = "vault.vagrant.local:8200"  
        tls_cert_file = "/opt/vault/tls/tls.crt"
        tls_key_file  = "/opt/vault/tls/tls.key"
    }  

    storage "file" {
      path = "/opt/vault/data" 
    }  

    #api_addr         = "http://0.0.0.0:8200"  
    api_addr         = "http://vault.vagrant.local:8200"  
 
vagrant@node1:~$ sudo systemctl enable vault  
-
    Created symlink /etc/systemd/system/multi-user.target.wants/vault.service → /lib/systemd/system/vault.service.   

    vagrant@node1:~$ systemctl status vault  
    ● vault.service - "HashiCorp Vault - A tool for managing secrets"  
         Loaded: loaded (/lib/systemd/system/vault.service; enabled; vendor preset: enabled)  
         Active: inactive (dead)  
           Docs: https://www.vaultproject.io/docs/  

vagrant@node1:~$ sudo systemctl start vault    
-
vagrant@node1:~$ systemctl status vault  
-
    ● vault.service - "HashiCorp Vault - A tool for managing secrets"  
         Loaded: loaded (/lib/systemd/system/vault.service; enabled; vendor preset: enabled)  
         Active: active (running) since Thu 2022-01-06 23:58:02 +04; 1s ago 
           Docs: https://www.vaultproject.io/docs/  
       Main PID: 1386 (vault)  
          Tasks: 7 (limit: 2320)  
         Memory: 17.3M  
         CGroup: /system.slice/vault.service  
                 └─1386 /usr/bin/vault server -config=/etc/vault.d/vault.hcl  

    Jan 06 23:58:02 node1 vault[1386]:               Listener 1: tcp (addr: "vault.vagrant.local:8200", cluster address: "192.168.1.17:8201", max_request_duration: ">  
    Jan 06 23:58:02 node1 vault[1386]:                Log Level: info  
    Jan 06 23:58:02 node1 vault[1386]:                    Mlock: supported: true, enabled: false  
    Jan 06 23:58:02 node1 vault[1386]:            Recovery Mode: false   
    Jan 06 23:58:02 node1 vault[1386]:                  Storage: file  
    Jan 06 23:58:02 node1 vault[1386]:                  Version: Vault v1.9.2  
    Jan 06 23:58:02 node1 vault[1386]:              Version Sha: f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf  
    Jan 06 23:58:02 node1 vault[1386]: ==> Vault server started! Log data will stream in below:  
    Jan 06 23:58:02 node1 vault[1386]: 2022-01-06T23:58:02.672+0400 [INFO]  proxy environment: http_proxy="\"\"" https_proxy="\"\"" no_proxy="\"\""  
    Jan 06 23:58:02 node1 vault[1386]: 2022-01-06T23:58:02.677+0400 [INFO]  core: Initializing VersionTimestamps for core  

vagrant@node1:~$ export VAULT_ADDR='http://vault.vagrant.local:8200'  
-
vagrant@node1:~$ echo "export VAULT_ADDR='http://vault.vagrant.local:8200'" >> /etc/environment  
-
vagrant@node1:~$ vault operator init  
-  
vagrant@node1:~$ vault policy write admin-policy.hcl - <<EOF  
-
    #Read system health check  
    path "sys/health"  
    {  
      capabilities = ["read", "sudo"]  
    }  

    #Create and manage ACL policies broadly across Vault  

    #List existing policies  
    path "sys/policies/acl"  
    {  
      capabilities = ["list"]  
    }  

    #Create and manage ACL policies  
    path "sys/policies/acl/*"  
    {  
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]  
    }

    #Enable and manage authentication methods broadly across Vault  

    #Manage auth methods broadly across Vault  
    path "auth/*"  
    {  
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]  
    }  

    #Create, update, and delete auth methods  
    path "sys/auth/*"  
    {  
      capabilities = ["create", "update", "delete", "sudo"]  
    }  

    #List auth methods  
    path "sys/auth"  
    {  
      capabilities = ["read"]  
    }  

    #Enable and manage the key/value secrets engine at `secret/` path  

    #List, create, update, and delete key/value secrets  
    path "secret/*"  
    {  
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]  
    }  

    #Manage secrets engines  
    path "sys/mounts/*"  
    {  
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]  
    }  

    #List existing secrets engines.  
    path "sys/mounts"  
    {  
      capabilities = ["read"]  
    }  

    #Enable secrets engine  
    path "sys/mounts/*" {  
      capabilities = [ "create", "read", "update", "delete", "list" ]  
    }

    #List enabled secrets engine  
    path "sys/mounts" {  
      capabilities = [ "read", "list" ]  
    }  

    #Work with pki secrets engine  
    path "pki*" {  
      capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]  
    }

    EOF  
# 4) Cоздайте центр сертификации по инструкции (ссылка) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).  

vagrant@node1:~$ vault secrets enable pki    
-
    Success! Enabled the pki secrets engine at: pki/    

vagrant@node1:~$  vault write -format=json pki_root_ca/root/generate/internal \  
-
        common_name="Root Certificate Authority" \  
        country="Russian Federation" \  
        locality="Saratov" \  
        street_address="Michurina 18" \  
        postal_code="413100" \  
        organization="DozFin LLC" \  
        ou="IT" \  
        ttl="262800h" > pki-root-ca.json  

vagrant@node1:~$ vault write pki_root_ca/config/urls \
-
    issuing_certificates="http://vault.vagrant.local:8200/v1/pki_root_ca/ca" \  
    crl_distribution_points="http://vault.vagrant.local:8200/v1/pki_root_ca/crl"  

vagrant@node1:~$  vault secrets enable \ 
-
    -path=pki_int_ca \  
    -description="PKI Intermediate CA" \  
    -max-lease-ttl="175200h" \  
    pki  

vagrant@node1:~$   vault write -format=json pki_int_ca/intermediate/generate/internal \
-
       common_name="Intermediate CA" \  
       country="Russian Federation" \  
       locality="Saratov" \  
       street_address="Michurina 18" \  
       postal_code="413100" \  
       organization="DozFin LLC" \  
       ou="IT" \  
       ttl="175200h" | jq -r '.data.csr' > pki_intermediate_ca.csr  

vagrant@node1:~$ vault write -format=json pki_root_ca/root/sign-intermediate csr=@pki_intermediate_ca.csr \
-
       country="Russian Federation" \  
       locality="Saratov" \  
       street_address="Michurina 18" \  
       postal_code="413100" \  
       organization="DozFin LLC" \  
       ou="IT" \  
       format=pem_bundle \  
       ttl="175200h" | jq -r '.data.certificate' > intermediateCA.cert.pem  

vagrant@node1:~$ vault write pki_int_ca/intermediate/set-signed \
-
    certificate=@intermediateCA.cert.pem  


vagrant@node1:~$ vault write pki_int_ca/config/urls \
-
    issuing_certificates="http://vault.vagrant.local:8200/v1/pki_int_ca/ca" \  
    crl_distribution_points="http://vault.vagrant.local:8200/v1/pki_int_ca/crl"  

vagrant@node1:~$  vault write pki_int_ca/roles/example-dot-com-server \
-
       country="Russian Federation" \  
       locality="Saratov" \  
       street_address="Michurina 18" \  
       postal_code="413100" \  
       organization="DozFin LLC" \  
       ou="IT" \  
        allowed_domains="vagrant.local" \  
        allow_subdomains="true" \  
        max_ttl="744h" \  
        key_bits="2048" \  
        key_type="rsa" \  
        allow_any_name="false" \  
        allow_bare_domains="false" \  
        allow_glob_domain="false" \  
        allow_ip_sans="true" \  
        allow_localhost="false" \  
        client_flag="false" \  
        server_flag="true" \  
        enforce_hostnames="true" \  
        key_usage="DigitalSignature,KeyEncipherment" \  
        ext_key_usage="ServerAuth" \  
        require_cn="true"  

vagrant@node1:~$   vault write pki_int_ca/roles/example-dot-com-client \
-
       country="Russian Federation" \  
       locality="Saratov" \  
       street_address="Michurina 18" \  
       postal_code="413100" \  
       organization="DozFin LLC" \  
       ou="IT" \  
        allow_subdomains="true" \  
        max_ttl="87600h" \  
        key_bits="2048" \  
        key_type="rsa" \  
        allow_any_name="true" \  
        allow_bare_domains="false" \  
        allow_glob_domain="false" \  
        allow_ip_sans="false" \  
        allow_localhost="false" \  
        client_flag="true" \  
        server_flag="false" \  
        enforce_hostnames="false" \  
        key_usage="DigitalSignature" \  
        ext_key_usage="ClientAuth" \  
        require_cn="true"  

vagrant@node1:~$   vault write -format=json pki_int_ca/issue/example-dot-com-server \
-
        common_name="nginx.vagrant.local" \  
        alt_names="nginx.vagrant.local" \  
        ttl="744h" > nginx.vagrant.local.crt  


vagrant@node1:~$  cat nginx.vagrant.local.crt | jq -r .data.certificate > nginx.vagrant.local.crt.pem
-
vagrant@node1:~$  cat nginx.vagrant.local.crt | jq -r .data.issuing_ca >> nginx.vagrant.local.crt.pem   
-
vagrant@node1:~$  cat nginx.vagrant.local.crt | jq -r .data.private_key > nginx.vagrant.local.crt.key    
-

# 5) Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.  
 Сертификат скопировал через wincp
 фото приложил 
 ![Сертификат корень](https://user-images.githubusercontent.com/72273619/148659825-4fd17855-63ee-4f17-9323-01f905369966.JPG)

# 6) Установите nginx.  

vagrant@node1:~$  sudo apt install nginx
-
    Reading package lists... Done  
    Building dependency tree  
    Reading state information... Done  
    The following additional packages will be installed:  
      fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0 libjpeg-turbo8 libjpeg8  
      libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5  
      libwebp6 libx11-6 libx11-data libxcb1 libxpm4 nginx-common nginx-core  
    Suggested packages:  
      libgd-tools fcgiwrap nginx-doc ssl-cert  
    The following NEW packages will be installed:  
      fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0 libjpeg-turbo8 libjpeg8  
      libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5  
      libwebp6 libx11-6 libx11-data libxcb1 libxpm4 nginx nginx-common nginx-core  
    0 upgraded, 20 newly installed, 0 to remove and 109 not upgraded.  
    Need to get 280 kB/3,165 kB of archives.  
    After this operation, 11.1 MB of additional disk space will be used.  
    Do you want to continue? [Y/n] y  
    Get:1 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libtiff5 amd64 4.1.0+git191117-2ubuntu0.20.04.2 [162 kB]  
    Get:2 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libgd3 amd64 2.2.5-5.2ubuntu2.1 [118 kB]  
    Fetched 280 kB in 0s (566 kB/s)  
    Preconfiguring packages ...  
    Selecting previously unselected package libxcb1:amd64.  
    (Reading database ... 41552 files and directories currently installed.)  
    Preparing to unpack .../00-libxcb1_1.14-2_amd64.deb ...  
    Unpacking libxcb1:amd64 (1.14-2) ...  
    Selecting previously unselected package libx11-data.  
    Preparing to unpack .../01-libx11-data_2%3a1.6.9-2ubuntu1.2_all.deb ...  
    Unpacking libx11-data (2:1.6.9-2ubuntu1.2) ...  
    Selecting previously unselected package libx11-6:amd64.  
    Preparing to unpack .../02-libx11-6_2%3a1.6.9-2ubuntu1.2_amd64.deb ...  
    Unpacking libx11-6:amd64 (2:1.6.9-2ubuntu1.2) ...  
    Selecting previously unselected package fonts-dejavu-core.  
    Preparing to unpack .../03-fonts-dejavu-core_2.37-1_all.deb ...  
    Unpacking fonts-dejavu-core (2.37-1) ...  
    Selecting previously unselected package fontconfig-config.  
    Preparing to unpack .../04-fontconfig-config_2.13.1-2ubuntu3_all.deb ...  
    Unpacking fontconfig-config (2.13.1-2ubuntu3) ...  
    Selecting previously unselected package libfontconfig1:amd64.  
    Preparing to unpack .../05-libfontconfig1_2.13.1-2ubuntu3_amd64.deb ...  
    Unpacking libfontconfig1:amd64 (2.13.1-2ubuntu3) ...  
    Selecting previously unselected package libjpeg-turbo8:amd64.  
    Preparing to unpack .../06-libjpeg-turbo8_2.0.3-0ubuntu1.20.04.1_amd64.deb ...  
    Unpacking libjpeg-turbo8:amd64 (2.0.3-0ubuntu1.20.04.1) ...  
    Selecting previously unselected package libjpeg8:amd64.  
    Preparing to unpack .../07-libjpeg8_8c-2ubuntu8_amd64.deb ...  
    Unpacking libjpeg8:amd64 (8c-2ubuntu8) ...  
    Selecting previously unselected package libjbig0:amd64.  
    Preparing to unpack .../08-libjbig0_2.1-3.1build1_amd64.deb ...  
    Unpacking libjbig0:amd64 (2.1-3.1build1) ...  
    Selecting previously unselected package libwebp6:amd64.  
    Preparing to unpack .../09-libwebp6_0.6.1-2ubuntu0.20.04.1_amd64.deb ...  
    Unpacking libwebp6:amd64 (0.6.1-2ubuntu0.20.04.1) ...  
    Selecting previously unselected package libtiff5:amd64.  
    Preparing to unpack .../10-libtiff5_4.1.0+git191117-2ubuntu0.20.04.2_amd64.deb ...  
    Unpacking libtiff5:amd64 (4.1.0+git191117-2ubuntu0.20.04.2) ...  
    Selecting previously unselected package libxpm4:amd64.  
    Preparing to unpack .../11-libxpm4_1%3a3.5.12-1_amd64.deb ...  
    Unpacking libxpm4:amd64 (1:3.5.12-1) ...  
    Selecting previously unselected package libgd3:amd64.  
    Preparing to unpack .../12-libgd3_2.2.5-5.2ubuntu2.1_amd64.deb ...  
    Unpacking libgd3:amd64 (2.2.5-5.2ubuntu2.1) ...  
    Selecting previously unselected package nginx-common.   
    Preparing to unpack .../13-nginx-common_1.18.0-0ubuntu1.2_all.deb ...  
    Unpacking nginx-common (1.18.0-0ubuntu1.2) ...  
    Selecting previously unselected package libnginx-mod-http-image-filter.  
    Preparing to unpack .../14-libnginx-mod-http-image-filter_1.18.0-0ubuntu1.2_amd64.deb ...  
    Unpacking libnginx-mod-http-image-filter (1.18.0-0ubuntu1.2) ...
    Selecting previously unselected package libnginx-mod-http-xslt-filter.  
    Preparing to unpack .../15-libnginx-mod-http-xslt-filter_1.18.0-0ubuntu1.2_amd64.deb ...  
    Unpacking libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.2) ...   
    Selecting previously unselected package libnginx-mod-mail.  
    Preparing to unpack .../16-libnginx-mod-mail_1.18.0-0ubuntu1.2_amd64.deb ...  
    Unpacking libnginx-mod-mail (1.18.0-0ubuntu1.2) ...  
    Selecting previously unselected package libnginx-mod-stream.  
    Preparing to unpack .../17-libnginx-mod-stream_1.18.0-0ubuntu1.2_amd64.deb ...  
    Unpacking libnginx-mod-stream (1.18.0-0ubuntu1.2) ...  
    Selecting previously unselected package nginx-core.  
    Preparing to unpack .../18-nginx-core_1.18.0-0ubuntu1.2_amd64.deb ...  
    Unpacking nginx-core (1.18.0-0ubuntu1.2) ...  
    Selecting previously unselected package nginx.  
    Preparing to unpack .../19-nginx_1.18.0-0ubuntu1.2_all.deb ...  
    Unpacking nginx (1.18.0-0ubuntu1.2) ...  
    Setting up libxcb1:amd64 (1.14-2) ...  
    Setting up nginx-common (1.18.0-0ubuntu1.2) ...  
    Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /lib/systemd/system/nginx.service.  
    Setting up libjbig0:amd64 (2.1-3.1build1) ...  
    Setting up libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.2) ...  
    Setting up libx11-data (2:1.6.9-2ubuntu1.2) ...  
    Setting up libwebp6:amd64 (0.6.1-2ubuntu0.20.04.1) ...  
    Setting up fonts-dejavu-core (2.37-1) ...  
    Setting up libjpeg-turbo8:amd64 (2.0.3-0ubuntu1.20.04.1) ...  
    Setting up libx11-6:amd64 (2:1.6.9-2ubuntu1.2) ...  
    Setting up libjpeg8:amd64 (8c-2ubuntu8) ...  
    Setting up libnginx-mod-mail (1.18.0-0ubuntu1.2) ...  
    Setting up libxpm4:amd64 (1:3.5.12-1) ...  
    Setting up fontconfig-config (2.13.1-2ubuntu3) ...  
    Setting up libnginx-mod-stream (1.18.0-0ubuntu1.2) ...  
    Setting up libtiff5:amd64 (4.1.0+git191117-2ubuntu0.20.04.2) ...  
    Setting up libfontconfig1:amd64 (2.13.1-2ubuntu3) ...  
    Setting up libgd3:amd64 (2.2.5-5.2ubuntu2.1) ...  
    Setting up libnginx-mod-http-image-filter (1.18.0-0ubuntu1.2) ...  
    Setting up nginx-core (1.18.0-0ubuntu1.2) ...  
    Setting up nginx (1.18.0-0ubuntu1.2) ...  
    Processing triggers for ufw (0.36-6) ...  
    Processing triggers for systemd (245.4-4ubuntu3.11) ...  
    Processing triggers for man-db (2.9.1-1) ...  
    Processing triggers for libc-bin (2.31-0ubuntu9.2) ...  

vagrant@node1:~$ systemctl status nginx
-
        ● nginx.service - nginx - high performance web server  
             Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)  
             Active: active (running) since Fri 2022-01-07 03:46:19 +04; 8s ago  
               Docs: https://nginx.org/en/docs/  
            Process: 14652 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)  
           Main PID: 14653 (nginx)  
              Tasks: 3 (limit: 2320)   
             Memory: 2.5M  
             CGroup: /system.slice/nginx.service  
                     ├─14653 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf  
                     ├─14654 nginx: worker process  
                     └─14655 nginx: worker process  

        Jan 07 03:46:19 node1 systemd[1]: Starting nginx - high performance web server...  
        Jan 07 03:46:19 node1 systemd[1]: Started nginx - high performance web server.  

sudo nano /etc/nginx/nginx.conf
-
        user  nginx;  
        worker_processes  auto;  

        error_log  /var/log/nginx/error.log notice;  
        pid        /var/run/nginx.pid;  

        events {  
            worker_connections  1024;  
            use epoll;  
        }   

        http {  
            include       /etc/nginx/mime.types;  
            include /etc/nginx/sites-enabled/*;  
            default_type  application/octet-stream;  
            server_names_hash_bucket_size 64;  
            log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '  
                              '$status $body_bytes_sent "$http_referer" '  
                              '"$http_user_agent" "$http_x_forwarded_for"';  

            access_log  /var/log/nginx/access.log  main;    

            sendfile        on;  
            tcp_nopush     on;  
            tcp_nodelay    on;  

vagrant@node1:~$ sudo mkdir -p /var/www/nginx.vagrant.local/html
-
vagrant@node1:~$ sudo chown -R $USER:$USER /var/www/nginx.vagrant.local/html  
-
vagrant@node1:~$ sudo chmod -R 755 /var/www/nginx.vagrant.local   
-
vagrant@node1:~$ sudo nano /var/www/nginx.vagrant.local/html/index.html  
-
    <html>  
        <head>  
        <title>Welcome to nginx.vagrant.local!</title>  
        </head>  
        <body>  
        <h1>Success!  The nginx.vagrant.local server block is working!</h1>  
        </body>  
    </html>  

vagrant@node1:~$ sudo mkdir /etc/nginx/sites-available
-
vagrant@node1:~$ sudo mkdir /etc/nginx/sites-enabled  
-
vagrant@node1:~$ sudo mkdir /etc/nginx/ssl  
-
vagrant@node1:~$ sudo cp nginx.vagrant.local.crt /etc/nginx/ssl/  
-
vagrant@node1:~$ sudo cp nginx.vagrant.local.crt.key /etc/nginx/ssl/
-
vagrant@node1:~$ sudo cp nginx.vagrant.local.crt.pem /etc/nginx/ssl/
-
vagrant@node1:~$ sudo nano /etc/nginx/sites-available/nginx.vagrant.local
-
    server {  
      listen              443 ssl;  
      server_name         nginx.vagrant.local;  
      ssl_certificate     /etc/nginx/ssl/nginx.vagrant.local.crt.pem;  
      ssl_certificate_key /etc/nginx/ssl/nginx.vagrant.local.crt.key;  
      ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;  
      ssl_ciphers         HIGH:!aNULL:!MD5;  

            root /var/www/nginx.vagrant.local/html;  
            index index.html index.htm index.nginx-debian.html;  
            server_name nginx.vagrant.local www.nginx.vagrant.local;  
              location / {  
                       try_files $uri $uri/ =404;  
             }  
      }  

vagrant@node1:~$ sudo ln -s /etc/nginx/sites-available/nginx.vagrant.local /etc/nginx/sites-enabled/  
-
vagrant@node1:~$ sudo nginx -t
-
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok  
    nginx: configuration file /etc/nginx/nginx.conf test is successful  

vagrant@node1:~$ sudo service nginx restart
-
vagrant@node1:~$ systemctl status nginx
-
        ● nginx.service - nginx - high performance web server  
               Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)  
               Active: active (running) since Fri 2022-01-07 03:46:19 +04; 8s ago  
               Docs: https://nginx.org/en/docs/  
               Process: 14652 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)  
               Main PID: 14653 (nginx)  
               Tasks: 3 (limit: 2320)   
               Memory: 2.5M  
        CGroup: /system.slice/nginx.service   
               ├─14653 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf  
               ├─14654 nginx: worker process  
               └─14655 nginx: worker process  

        Jan 07 03:46:19 node1 systemd[1]: Starting nginx - high performance web server...  
        Jan 07 03:46:19 node1 systemd[1]: Started nginx - high performance web server.  

# 7) По инструкции (ссылка) настройте nginx на https, используя ранее подготовленный сертификат: 
* можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;  
* можно использовать и другой html файл, сделанный вами;  
* Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.  

vagrant@node1:~$ sudo mkdir /etc/nginx/ssl
-
vagrant@node1:~$ sudo cp nginx.vagrant.local.crt /etc/nginx/ssl/
-
vagrant@node1:~$ sudo cp nginx.vagrant.local.crt.key /etc/nginx/ssl/
-
vagrant@node1:~$ sudo cp nginx.vagrant.local.crt.pem /etc/nginx/ssl/
-
vagrant@node1:~$ sudo nano /etc/nginx/sites-available/nginx.vagrant.local
-
        server {  
                listen              443 ssl;  
            server_name         nginx.vagrant.local;  
            ssl_certificate     /etc/nginx/ssl/nginx.vagrant.local.crt.pem;  
            ssl_certificate_key /etc/nginx/ssl/nginx.vagrant.local.crt.key;  
            ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;  
            ssl_ciphers         HIGH:!aNULL:!MD5;  

                root /var/www/nginx.vagrant.local/html;  
                index index.html index.htm index.nginx-debian.html;  

                server_name nginx.vagrant.local www.nginx.vagrant.local;  

                location / { 
                        try_files $uri $uri/ =404;  
                }  
        }  

фото приложил сайт с сертификатом.  
![сайтссертификатом](https://user-images.githubusercontent.com/72273619/148659817-333335e5-b716-4188-bc94-480f8bb3a73e.JPG)

# 8)Создайте скрипт, который будет генерировать новый сертификат в vault:  
* генерируем новый сертификат так, чтобы не переписывать конфиг nginx;  
* перезапускаем nginx для применения нового сертификата.  

vagrant@node1:~$ sudo touch /etc/nginx/ssl/pwd.crt
 -  
vagrant@node1:~$ sudochmod u=rwx,g=r,o= /etc/nginx/ssl/pwd.crt
-
vagrant@node1:~$ sudo touch /etc/nginx/ssl/pki.sh  
-
    #!/usr/bin/bash
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
    sleep 5
    psw1=$(sudo cat /etc/nginx/ssl/pwd.crt | jq -r .data.ps1)
    sleep 2
    psw2=$(sudo cat /etc/nginx/ssl/pwd.crt | jq -r .data.ps2)
    sleep 2
    psw3=$(sudo cat /etc/nginx/ssl/pwd.crt | jq -r .data.ps3)
    sleep 2
    psw4=$(sudo cat /etc/nginx/ssl/pwd.crt | jq -r .data.ps)
    sleep 5
    vault operator unseal $psw1 > /dev/null
    sleep 5
    vault operator unseal $psw2 > /dev/null
    sleep 5
    vault operator unseal $psw3 > /dev/null
    sleep 5
    vault login $psw4 > /dev/null
    sleep 5
    vault status
    sleep 5
    SN=$(cat /etc/nginx/ssl/nginx.vagrant.local.crt | jq -r .data.serial_number)
    sleep 5
    vault write pki_int_ca/revoke serial_number=$SN
    sleep 5
    vault write -format=json pki_int_ca/issue/example-dot-com-server \
        common_name="nginx.vagrant.local" \
        alt_names="nginx.vagrant.local" \
        ttl="744h" >  /etc/nginx/ssl/nginx.vagrant.local.crt
    sleep 5
    cat /etc/nginx/ssl/nginx.vagrant.local.crt | jq -r .data.certificate > /etc/nginx/ssl/nginx.vagrant.local.crt.pem
    sleep 5
    cat /etc/nginx/ssl/nginx.vagrant.local.crt | jq -r .data.issuing_ca >> /etc/nginx/ssl/nginx.vagrant.local.crt.pem
    sleep 5
    cat /etc/nginx/ssl/nginx.vagrant.local.crt | jq -r .data.private_key > /etc/nginx/ssl/nginx.vagrant.local.crt.key
    sleep 5
    systemctl restart nginx

vagrant@node1:~$ sudo chmod u=rwx,g=r,o= /etc/nginx/ssl/pwd.crt
-
vagrant@node1:~$ sudo chmod +x /etc/nginx/ssl/pki.sh  
-
# 9)Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.  

vagrant@node1:~$ sudo crontab -e  
-
    0 0 6 * * /etc/nginx/ssl/pki.sh && systemctl restart nginx    

фото прикладываю.  
![cronlog1](https://user-images.githubusercontent.com/72273619/148659806-50bc7a1e-f7b2-41cf-93e4-1a82b10790e1.JPG)
![cronlog2](https://user-images.githubusercontent.com/72273619/148659810-89c192e6-b89f-4fd7-908d-38e63b67a7eb.JPG)
