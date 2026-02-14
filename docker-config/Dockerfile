FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath \
    && apt-get clean && rm -rf /var/lib/apt/lists/*




# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files first for dependency caching
COPY composer.json composer.lock* /var/www/html/

# Install PHP dependencies
RUN composer update --no-dev --optimize-autoloader --no-interaction || true

# Copy application files
COPY . /var/www/html

# Set permissions
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html/storage \
    && chown -R www-data:www-data /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache


# Expose port 8000 for artisan serve
EXPOSE 8000

