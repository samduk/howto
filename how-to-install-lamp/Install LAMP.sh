#!/bin/bash

# Update and upgrade the system
echo "Updating the system..."
sudo apt update && sudo apt upgrade -y

# Install Apache
echo "Installing Apache..."
sudo apt install apache2 -y

# Enable Apache to start at boot and restart the service
echo "Enabling Apache and restarting..."
sudo systemctl enable apache2
sudo systemctl restart apache2

# Install MySQL
echo "Installing MySQL..."
sudo apt install mysql-server -y

# Secure MySQL installation (optional: interactive or automated part)
echo "Securing MySQL..."
sudo mysql_secure_installation

# Install PHP
echo "Installing PHP and necessary modules..."
sudo apt install php libapache2-mod-php php-mysql -y

# Restart Apache to load PHP module
echo "Restarting Apache to apply PHP settings..."
sudo systemctl restart apache2

# Create a test PHP file
echo "Creating a PHP test file..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Output success message
echo "LAMP installation complete. You can verify PHP by visiting http://your_server_ip/info.php"

