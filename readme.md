# Setup laravel project container

## install composer

https://getcomposer.org/download/

## Setup laravel project

```bash
composer create-project --prefer-dist laravel/laravel laravel-app
cd laravel-app
```

## Dockerize the Laravel App with Nginx

In your Laravel project root, create a Dockerfile:

```Dockerfile
FROM php:8.3-fpm

# Install system dependencies
RUN apt update && apt install -y libpng-dev libonig-dev libxml2-dev zip curl unzip git nginx net-tools netcat-traditional && apt clean

# setup node
RUN curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh && chmod +x nodesource_setup.sh && bash nodesource_setup.sh && apt install -y nodejs && apt clean

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . /var/www

# Copy the nginx config
COPY default.conf /etc/nginx/sites-available/default
COPY start.sh /start.sh

# Give execute permissions to the start script
RUN chmod +x /start.sh

# set permissions for project
RUN chown -R www-data:www-data /var/www

# update composer and install npm
RUN composer update && npm install && npm run build


CMD ["/start.sh"]
```

In the above Dockerfile, you would also need an Nginx configuration (default.conf). Here's a basic example:

```ini
server {
    listen 80;

    index index.php index.html;
    root /var/www/public;
    error_log /var/log/nginx/error.log debug;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

add this config to the main laravel dir with the docker file

you will also need to add a script to start the php-fpm process, you can find it with `whereis php-fpm`

```bash
cat <<EOF | sudo tee start.sh
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
EOF
```

be sure to make it executable

```bash
chmod +x start.sh
```

This will run php-fpm in the background, followed by nginx in the foreground when the container starts, ensuring that both services are available and running.


## Edit env file

set this in env file, the env file will be ignored by gitignore file created by default, either manually inject or remove ignore. The hostname (DB_HOST) is the name of the MySQL service you'll create in Kubernetes or the name of the docker container in docker compose.

```env
DB_CONNECTION=mysql
DB_HOST=mysql           # Use DNS name or IP, name of container for compose, name of K8s Service in K8s
DB_PORT=3306
DB_DATABASE=laravel-app
DB_USERNAME=root
DB_PASSWORD=password
```


## build and push the image to container registry

**This Part is automated by our [pipeline](./.github/workflows/docker-release.yaml)**

### build

```bash
docker build -t edgeforge-labs/laravel-app .
```

### tag

```bash
docker tag local-image:tagname new-repo:tagname
```

### push

```bash
docker push edgeforge-labs/laravel-app
```

### my examples:

````bash
docker build -t edgeforge-labs/laravel-app .
docker tag edgeforge-labs/laravel-app:latest edgeforge-labs/laravel-app:latest
docker push edgeforge-labs/laravel-app:latest
````


## run php aritsan migrate

for this the db needs to be connected, we added a step for this in the startup script.

## Deploy created image via docker compose

Docker compose is the default way to use this container. The [compose file](./website/docker-compose.yaml) can be found in the [app root](./website). Just run it and verify functionality at ``http://localhost:8080``

## Deploy created image via kubernetes

under manifests/ there is a ful deploy.yml, this has all the manifests needed to make the app, PV still needs to be added but all the rest is there.
