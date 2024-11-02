#!/bin/sh

export DB_HOST="mysql"

# Wait for MySQL to be ready
echo "Waiting for MySQL to be available..."

until nc -z "$DB_HOST" 3306; do
  echo "MySQL is unavailable - waiting..."
  sleep 3
done

echo "MySQL is available - continuing with migrations..."

# Run Laravel commands
php artisan key:generate
php artisan migrate --force  # Use --force in production to run migrations non-interactively

# Start PHP-FPM in the background
php-fpm -D

# Start nginx in the foreground
nginx -g "daemon off;"
