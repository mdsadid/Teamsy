# =====================
# Build Stage: Composer
# =====================
FROM composer:2 AS backend

WORKDIR /app

# Copy only composer files first for caching
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Then copy the rest of the app
COPY . .

# =================
# Build Stage: Node
# =================
FROM node:20 AS frontend

WORKDIR /app

# Copy only what's needed for npm first (for caching)
COPY package*.json ./
RUN npm ci

# Copy the rest of the files (including resources, vite.config.js, etc.)
COPY . .

# Run Vite production build
RUN npm run build

# =============================
# Production Stage: PHP + Nginx
# =============================
FROM php:8.2-fpm

# Install Nginx and system packages
RUN apt-get update && apt-get install -y \
    nginx curl zip unzip git libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql zip bcmath opcache \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Copy Laravel app (with vendor)
COPY --from=backend /app /var/www/html

# Copy built Vite assets
COPY --from=frontend /app/public/build /var/www/html/public/build

# Copy custom Nginx config
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port for Render
EXPOSE 8080

# Start Nginx and PHP-FPM
CMD ["sh", "-c", "nginx -g 'daemon off;' & php-fpm"]
