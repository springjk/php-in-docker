FROM php:5.6-apache

# add source
ADD code/ /var/www/html/

# setting php
ADD php/php.ini /usr/local/etc/php/php.ini

# install base tool
ADD php/sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
	git \
    libmcrypt-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng12-dev \
    && rm -r /var/lib/apt/lists/*

# install php extension
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install zip \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql

# composer
ADD php/composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

WORKDIR /var/www/html/

RUN composer install --optimize-autoloader

RUN a2enmod rewrite

RUN usermod -u 1000 www-data

EXPOSE 80

VOLUME ["/var/www/html"]
