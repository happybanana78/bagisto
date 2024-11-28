FROM php:8.2-fpm

# General packages installation
RUN apt update && apt install -y libfreetype-dev libjpeg62-turbo-dev libpng-dev zlib1g-dev libzip-dev libonig-dev libicu-dev libwebp-dev libxpm-dev unzip
RUN docker-php-ext-configure gd \
    --with-webp \
    --with-jpeg \
    --with-xpm \
    --with-freetype
RUN docker-php-ext-install gd
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath intl zip

# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && apt-get install -y nodejs

# Set PHP configurations
RUN echo "file_uploads=On" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "memory_limit=512M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "upload_max_filesize=64M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "post_max_size=64M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "max_execution_time=600" >> /usr/local/etc/php/conf.d/uploads.ini

# Set working directory and copy files
WORKDIR /var/www/bagisto
COPY . .

# Set storage dicrectory permissions
RUN chown -R www-data:www-data /var/www/bagisto && chmod -R 775 /var/www/bagisto/storage

# Run php-fpm
CMD ["php-fpm"]
