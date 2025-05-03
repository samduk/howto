
---

# Switching Between Multiple PHP Versions on a Linux Server

**Note:** This guide assumes that multiple PHP versions are already installed on your system.

---

## Step 1: Select the Default PHP CLI Version

Use the following command to configure the default PHP version used by the command line interface (CLI):

```
sudo update-alternatives --config php
```

You will be prompted to select from the available PHP versions. Enter the corresponding selection number (e.g., `0`, `1`, `2`) and press `Enter`.

---

## Step 2: Enable the Desired PHP Module for Apache

For example, to enable PHP 8.3:

```
sudo a2enmod php8.3
```

---

## Step 3: Disable the Previously Active PHP Module

To prevent conflicts, disable the previously enabled PHP version. For example, if PHP 8.1 was active:

```
sudo a2dismod php8.1
```

Then, reload the web server:

For **Apache**:

```
sudo systemctl reload apache2
```

For **Nginx** (if PHP is handled via PHP-FPM):

```
sudo systemctl reload nginx
```

---

## Step 4: Verify the Active PHP Version via `phpinfo()`

Create a file named `info.php` with the following content:

```
<?php
echo phpinfo();
?>
```

Place the file in your web root directory. For example:

```
/var/www/html/myapp/public/info.php
```

Then, navigate to the file in your browser (e.g., `http://yourdomain.com/public/info.php`) and verify that the correct PHP version is active.

---

## Conclusion

You have now successfully switched between PHP versions and verified the change.
For security reasons, remember to remove the `info.php` file after use.

---

