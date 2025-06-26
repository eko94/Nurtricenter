#!/bin/bash

# Custom post-deployment script for Laravel

echo "Configurando permisos para Laravel..."

# Asegurar que los directorios existan
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/storage/framework/cache
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/bootstrap/cache

# Configurar permisos correctos ANTES de cualquier operación de Laravel
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Asegurar que el archivo de log sea escribible
touch /var/www/html/storage/logs/laravel.log
chown www-data:www-data /var/www/html/storage/logs/laravel.log
chmod 664 /var/www/html/storage/logs/laravel.log

echo "Permisos configurados correctamente"

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