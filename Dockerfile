# ============================
# 1. Base PHP Image
# ============================
FROM php:8-fpm-alpine

# Set working directory
WORKDIR /var/www/html

# ============================
# 2. System Dependencies
# ============================
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# ============================
# 3. Install Composer
# ============================
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ============================
# 4. Copy Application Code
# ============================
COPY . .

# ============================
# 5. Install PHP Dependencies
# ============================
RUN composer install --no-dev --optimize-autoloader

# ============================
# 6. Set Permissions
# ============================
RUN chown -R www-data:www-data storage bootstrap/cache

# ============================
# 7. Expose Port
# ============================
EXPOSE 8000

# ============================
# 8. Start Laravel Server
# ============================
CMD php artisan serve --host=0.0.0.0 --port=8000
