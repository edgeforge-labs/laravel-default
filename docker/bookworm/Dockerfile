FROM php:8.3-fpm

# Install system dependencies
RUN apt update && apt install -y libpng-dev libonig-dev libxml2-dev zip curl unzip git nginx net-tools netcat-traditional && apt clean

# setup node
RUN curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh && chmod +x nodesource_setup.sh && bash nodesource_setup.sh && apt install -y nodejs && apt clean

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl sodium ctype curl dom
     
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

# Generate the Application Key & Migrate DB => moved to start script
# RUN php artisan key:generate

CMD ["/start.sh"]
