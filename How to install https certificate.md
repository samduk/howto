# Server Setup 
1. Ubuntu Server 20.04.x LTS
2. **Self Signed Certification Installation**
3. LAMP stack Installation 
4. Laravel Installation (main thing, composer installation)
***

## 2 Self Signed Certification Installation 
- Certificate is valid for 5 years however, we need to patch the system based on the open disclosed vulnerabilities.
***

### Steps 

```
sudo apt-get install apache2 openssl -y

sudo openssl req -nodes -newkey rsa:2048 -keyout /etc/ssl/private/private.key -out /etc/ssl/private/request.csr

sudo openssl x509 -in /etc/ssl/private/request.csr -out /etc/ssl/private/certificate.crt -req -signkey /etc/ssl/private/private.key -days 2000
```

```
sudo vim /etc/apache2/sites-available/default-ssl.conf
```
```
<IfModule mod_ssl.c>
<VirtualHost _default_:443>
ServerAdmin suport@epotala.com
ServerName app-server-ip
DocumentRoot /var/www/html

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

SSLEngine on
SSLCertificateFile /etc/ssl/private/certificate.crt
SSLCertificateKeyFile /etc/ssl/private/private.key

<FilesMatch "\.(cgi|shtml|phtml|php)$">
SSLOptions +StdEnvVars
</FilesMatch>
<Directory /usr/lib/cgi-bin>
SSLOptions +StdEnvVars
</Directory>

</VirtualHost>
</IfModule>
```

```
sudo a2ensite default-ssl.conf
```

```
sudo vim /etc/apache2/sites-available/000-default.conf
```
```
<VirtualHost *:80>

ServerAdmin admin@example.com
ServerName application-server-ip
DocumentRoot /var/www/html

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

Redirect "/" "https://application-server-ip/
</VirtualHost>
```
```
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod rewrite 
```

```
sudo systemctl restart apache2 
```
