# Use an official PHP image as the base image
FROM php:8.1-apache

# Install required extensions and oniguruma
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libexif-dev \
    libjpeg-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \  
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    curl \
    fileinfo \
    exif \
    mbstring \
    gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite
RUN docker-php-ext-install -j$(nproc) mysqli

# Configure GD extension with freetype and jpeg support
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the application files to the container
COPY . /var/www/html

# Expose port 80 for Apache
EXPOSE 81

# Set permissions for the cache directory
RUN chmod -R 777 writable/cache

RUN chown -R www-data:www-data /var/www/html


# Start Apache in the foreground
CMD ["apache2-foreground"]
