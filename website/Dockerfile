# [Offical Docs](https://laravel.com/docs/11.x/deployment)
FROM php:8.3-fpm-alpine

# Install system dependencies
RUN apk update && \
    apk add --no-cache \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    curl \
    unzip \
    git \
    nginx \
    net-tools \
    nodejs npm \
    libsodium-dev \
    icu-dev \
    curl-dev \
    openssl-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libzip-dev \
    netcat-openbsd && \
    rm -rf /var/cache/apk/*

# Install PHP extensions | https://laravel.com/docs/11.x/deployment#server-requirements
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath intl zip # gd ctype curl dom fileinfo filter hash mbstring pdo session tokenizer xml pcre openssl sodium | no need to enable these extensions they come prepacked by php8.3

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . /var/www

# Copy the nginx config
COPY default.conf /etc/nginx/http.d/default.conf
COPY start.sh /start.sh

# Give execute permissions to the start script
RUN chmod +x /start.sh

# Set permissions for the project
RUN chown -R www-data:www-data /var/www

# Update Composer and install npm packages
RUN composer update && npm install && npm run build

CMD ["/start.sh"]
