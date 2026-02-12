#!/bin/sh

# Fix permissions for storage and cache directories
# This is crucial when mounting volumes in development
if [ -d "/var/www/html/storage" ]; then
    chown -R www-data:www-data /var/www/html/storage
    chmod -R 777 /var/www/html/storage
fi

if [ -d "/var/www/html/bootstrap/cache" ]; then
    chown -R www-data:www-data /var/www/html/bootstrap/cache
    chmod -R 777 /var/www/html/bootstrap/cache
fi

# Ensure composer dependencies are installed if vendor is missing
if [ ! -d "/var/www/html/vendor" ] && [ -f "/var/www/html/composer.json" ]; then
    echo "Vendor directory not found, running composer install..."
    composer install --no-dev --optimize-autoloader --no-interaction
fi

# Start SSH
/usr/sbin/sshd

# Start PHP-FPM
exec php-fpm
