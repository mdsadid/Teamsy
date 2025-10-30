# =====================
# Build Stage: Composer
# =====================
FROM composer:2 AS backend

WORKDIR /app

# Copy full Laravel project and install PHP deps
COPY . .
RUN composer install --no-dev --optimize-autoloader

# =================
# Build Stage: Node
# =================
FROM node:20 AS frontend

WORKDIR /app

# Copy files from backend stage
COPY --from=backend /app /app

ENV VITE_ASSET_URL=https://teamsy.onrender.com

# Install and build frontend assets
RUN npm ci
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

# Copy Laravel app (with vendor + built assets)
COPY --from=backend /app /var/www/html
COPY --from=frontend /app/public/build /var/www/html/public/build

# Copy custom Nginx config
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port for Render
EXPOSE 8080

# Start Nginx and PHP-FPM
CMD ["sh", "-c", "nginx -g 'daemon off;' & php-fpm"]
