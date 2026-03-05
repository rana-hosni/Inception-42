FROM debian:bookworm

RUN apt update && apt upgrade -y && \
    apt install -y \
    # mariadb-client \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    php8.2-opcache \
    wget \
    curl \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Copy PHP-FPM configuration
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy WordPress installation script
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

# Create necessary directories
RUN mkdir -p /run/php && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/setup.sh"]