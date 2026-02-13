FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    zip \
    unzip \
    libzip-dev \
    wget \
    sudo \
    dos2unix \
    openssh-server \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN mkdir -p /var/run/sshd
RUN useradd -m -s /bin/bash -G sudo dev && \
    echo 'dev:@111PasswordContainer' | chpasswd && \
    echo 'root:@111PasswordContainer' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd



# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files first for dependency caching
COPY composer.json composer.lock* /var/www/html/

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction || true

# Copy application files
COPY . /var/www/html

# Set permissions
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html/storage \
    && chown -R www-data:www-data /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# Copy and setup startup script
COPY docker-config/config/docker/start-container.sh /usr/local/bin/start-container.sh
RUN dos2unix /usr/local/bin/start-container.sh && chmod +x /usr/local/bin/start-container.sh

# Expose port 9000 for FPM and 22 for SSH
EXPOSE 9000 22

CMD ["/usr/local/bin/start-container.sh"]
