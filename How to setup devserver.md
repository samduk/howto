# Overview
1. Ubuntu Server Installation 
2. Extending Storage Space 
3. Setting up static IP address
4. LAMP Installation 
5. Self Signed Certification Installation
***
# 1. Ubuntu Server Installation 
-	We are using ubuntu server 24.04 LTS 
-	We will not cover how to install uBuntu OS into server (We will need to Encrypt the Hard Disk during the installation)

# 2. Extending Storage Space 
**Check the current size of the logical volume before making any changes**
```
df -Th /dev/mapper/ubuntu--vg-ubuntu--lv
```

**Run a test first**
```
sudo lvresize -tvl +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
```

**Resize the logical volume** 
```
sudo lvresize -vl +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
```
    
**Resize the filesystem** 
```
sudo resize2fs -p /dev/mapper/ubuntu--vg-ubuntu--lv
```
 
 **Check the size of the logical volume to see if everything went smooth** 
 
 ```
df -hT /dev/mapper/ubuntu--vg-ubuntu--lv
```

<div style="page-break-after: always;"></div>

# 3. Setting up Static IP Address 
```
cat /etc/netplan/00-installer-config.yaml
```
## netplan entry of the eFiling Server 
```
# This is the network config written by 'subiquity'
network:
  version: 2
  ethernets:
    eno1:
      dhcp4: no
      addresses:
        - 192.168.56.187/24
      routes:
        - to: default
          via: 192.168.56.1
      nameservers:
        addresses:
          - 8.8.8.8      # Google's DNS server
          - 8.8.4.4      # Alternate Google's DNS server

```
Note: All the spacing (identation should be placed with help of **spacebar** not the **tab key**). Spacing should be either two spaces or 4 spaces. 

<div style="page-break-after: always;"></div>
 # 4. LAMP Installation 
## Installation of Apache & OpenSSL 
```
sudo apt update -y && sudo apt upgrade -y 
sudo apt install apache2 -y && sudo apt install openssl -y 
```

## Installation of MySQL Server and Hardening
```
sudo apt update -y && sudo apt upgrade -y
```
```
sudo apt install mysql-server -y 
sudo mysql_secure_installation 
```

## Installation of PHP 8.x

### Add PPA 
```
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
```

### Install PHP 
```
sudo apt install php8.1
```

### Install PHP 8.1 Extensions
```
sudo apt install php8.1-common php8.1-mysql php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-dev php8.1-imap php8.1-mbstring php8.1-opcache php8.1-soap php8.1-zip php8.1-redis php8.1-intl -y
```

### Configure PHP 8.1 
```
sudo vim /etc/php/8.1/apache2/php.ini
```


### Customize the following values based on project requirements
```
upload_max_filesize = 32M 
post_max_size = 48M 
memory_limit = 256M 
max_execution_time = 600 
max_input_vars = 3000 
max_input_time = 1000
```
***

Incase you need to downgrade from PHP8.1

## Install PHP 7.4 
```
sudo apt-get install -y php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath
```

### Downgrade to PHP 8.1 for Apache 

```
sudo a2dismod php8.1
sudo a2enmod php7.4
reboot
```

Note: 
- How to setup WordPress on Dev Server will be linked here. 
- It is important to make a folder at /var/log/apache2/ for your particular project and then change the ownership. For example, 
	- ```sudo mkdir samdup.tw```
	- ```sudo chown root:adm samdup.tw```

# 5. Self Signed Certification Installation 
```
sudo apt-get install apache2 openssl -y

sudo openssl req -nodes -newkey rsa:2048 -keyout /etc/ssl/private/private.key -out /etc/ssl/private/request.csr

sudo openssl x509 -in /etc/ssl/private/request.csr -out /etc/ssl/private/certificate.crt -req -signkey /etc/ssl/private/private.key -days 2000
```

### Complete Entry of the new.bod.asia.conf (for refence)
```
<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin hello@epotala.com
                ServerName new.epotala.com
                DocumentRoot /var/www/html/new.epotala.com

                # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
                # error, crit, alert, emerg.
                # It is also possible to configure the loglevel for particular
                # modules, e.g.
                #LogLevel info ssl:warn

                ErrorLog ${APACHE_LOG_DIR}/epotala/error.log
                CustomLog ${APACHE_LOG_DIR}/epotala/access.log combined

                # For most configuration files from conf-available/, which are
                # enabled or disabled at a global level, it is possible to
                # include a line for only one particular virtual host. For example the
                # following line enables the CGI configuration for this host only
                # after it has been globally disabled with "a2disconf".
                #Include conf-available/serve-cgi-bin.conf

                #   SSL Engine Switch:
                #   Enable/Disable SSL for this virtual host.
                SSLEngine on

                #   A self-signed (snakeoil) certificate can be created by installing
                #   the ssl-cert package. See
                #   /usr/share/doc/apache2/README.Debian.gz for more info.
                #   If both key and certificate are stored in the same file, only the
                #   SSLCertificateFile directive is needed.
                #SSLCertificateFile     /etc/ssl/certs/ssl-cert-snakeoil.pem
                #SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

                SSLCertificateFile      /etc/ssl/private/certificate.crt 
                SSLCertificateKeyFile /etc/ssl/private/private.key
                #   Server Certificate Chain:
                #   Point SSLCertificateChainFile at a file containing the
                #   concatenation of PEM encoded CA certificates which form the
                #   certificate chain for the server certificate. Alternatively
                #   the referenced file can be the same as SSLCertificateFile
                #   when the CA certificates are directly appended to the server
                #   certificate for convinience.
                #SSLCertificateChainFile /etc/apache2/ssl.crt/server-ca.crt

                #   Certificate Authority (CA):
                #   Set the CA certificate verification path where to find CA
                #   certificates for client authentication or alternatively one
                #   huge file containing all of them (file must be PEM encoded)
                #   Note: Inside SSLCACertificatePath you need hash symlinks
                #                to point to the certificate files. Use the provided
                #                Makefile to update the hash symlinks after changes.
                #SSLCACertificatePath /etc/ssl/certs/
                #SSLCACertificateFile /etc/apache2/ssl.crt/ca-bundle.crt

                #   Certificate Revocation Lists (CRL):
                #   Set the CA revocation path where to find CA CRLs for client
                #   authentication or alternatively one huge file containing all
                #   of them (file must be PEM encoded)
                #   Note: Inside SSLCARevocationPath you need hash symlinks
                #                to point to the certificate files. Use the provided
                #                Makefile to update the hash symlinks after changes.
                #SSLCARevocationPath /etc/apache2/ssl.crl/
                #SSLCARevocationFile /etc/apache2/ssl.crl/ca-bundle.crl

                #   Client Authentication (Type):
                #   Client certificate verification type and depth.  Types are
                #   none, optional, require and optional_no_ca.  Depth is a
                #   number which specifies how deeply to verify the certificate
                #   issuer chain before deciding the certificate is not valid.
                #SSLVerifyClient require
                #SSLVerifyDepth  10

                #   SSL Engine Options:
                #   Set various options for the SSL engine.
                #   o FakeBasicAuth:
                #        Translate the client X.509 into a Basic Authorisation.  This means that
                #        the standard Auth/DBMAuth methods can be used for access control.  The
                #        user name is the `one line' version of the client's X.509 certificate.
                #        Note that no password is obtained from the user. Every entry in the user
                #        file needs this password: `xxj31ZMTZzkVA'.
                #   o ExportCertData:
                #        This exports two additional environment variables: SSL_CLIENT_CERT and
                #        SSL_SERVER_CERT. These contain the PEM-encoded certificates of the
                #        server (always existing) and the client (only existing when client
                #        authentication is used). This can be used to import the certificates
                #        into CGI scripts.
                #   o StdEnvVars:
                #        This exports the standard SSL/TLS related `SSL_*' environment variables.
                #        Per default this exportation is switched off for performance reasons,
                #        because the extraction step is an expensive operation and is usually
                #        useless for serving static content. So one usually enables the
                #        exportation for CGI and SSI requests only.
                #   o OptRenegotiate:
                #        This enables optimized SSL connection renegotiation handling when SSL
                #        directives are used in per-directory context.
                #SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>
                #TCRC gang added the foillowing line
                <Directory />
                        Options FollowSymLinks
                        AllowOverride None 
                </Directory> 
                <Directory /var/www/html/new.epotala.com>
                        AllowOverride All 
                </Directory>
                #   SSL Protocol Adjustments:
                #   The safe and default but still SSL/TLS standard compliant shutdown
                #   approach is that mod_ssl sends the close notify alert but doesn't wait for
                #   the close notify alert from client. When you need a different shutdown
                #   approach you can use one of the following variables:
                #   o ssl-unclean-shutdown:
                #        This forces an unclean shutdown when the connection is closed, i.e. no
                #        SSL close notify alert is send or allowed to received.  This violates
                #        the SSL/TLS standard but is needed for some brain-dead browsers. Use
                #        this when you receive I/O errors because of the standard approach where
                #        mod_ssl sends the close notify alert.
                #   o ssl-accurate-shutdown:
                #        This forces an accurate shutdown when the connection is closed, i.e. a
                #        SSL close notify alert is send and mod_ssl waits for the close notify
                #        alert of the client. This is 100% SSL/TLS standard compliant, but in
                #        practice often causes hanging connections with brain-dead browsers. Use
                #        this only for browsers where you know that their SSL implementation
                #        works correctly.
                #   Notice: Most problems of broken clients are also related to the HTTP
                #   keep-alive facility, so you usually additionally want to disable
                #   keep-alive for those clients, too. Use variable "nokeepalive" for this.
                #   Similarly, one has to force some clients to use HTTP/1.0 to workaround
                #   their broken HTTP/1.1 implementation. Use variables "downgrade-1.0" and
                #   "force-response-1.0" for this.
                # BrowserMatch "MSIE [2-6]" \
                #               nokeepalive ssl-unclean-shutdown \
                #               downgrade-1.0 force-response-1.0

        </VirtualHost>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
```





### Additional Information 
For new developers we can create individual account, using the following commands 
```
sudo adduser test
sudo usermod -aG sudo test #this command will help to make the user sudoers
```

## Useradd 
```
#!/usr/bin/bash 
        sudo useradd -s /bin/bash -m -c "samdup" -U epotala01
        sudo usermod -aG sudo epotala01
        echo "epotala01:epotala@123!" | chpasswd 
        sudo chage -d 0 epotala01 
        sudo chage -M 30 epotala01
        sudo chage -W 1 epotala01
```

Note: You have to replace the **samdup** and **epotala01** from above. The dummy new staff's username is epotala01 and his/her one time password is **epotala@123!**.  Above script will force the user to change the password after using the initial password. 

