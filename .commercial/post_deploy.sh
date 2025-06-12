#!/bin/bash

# Custom post-deployment script for Laravel

# Asegurar permisos correctos para Laravel
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy the .env.example to .env
cp /var/www/html/.env.example /var/www/html/.env

# Generate the Laravel application key
php artisan key:generate

php artisan migrate

# Configurar cron para publicar eventos
echo "* * * * * cd /var/www/html && php artisan commercial:publish-events >> /var/log/cron.log 2>&1" > /etc/cron.d/publish-events
chmod 0644 /etc/cron.d/publish-events
crontab /etc/cron.d/publish-events

# Iniciar cron
service cron start


# Iniciar Apache en segundo plano
apache2-foreground &

# Iniciar el script de procesamiento de eventos en segundo plano
/usr/local/bin/process-events.sh > /var/log/events-processor.log 2>&1 &

# Mantener el contenedor en ejecución
tail -f /var/log/apache2/error.log 