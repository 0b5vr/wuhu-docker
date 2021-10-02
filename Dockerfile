FROM php:7.3-fpm

ENV LANG C.UTF-8
ENV HOME /root

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  mariadb-client

# Ref: https://stackoverflow.com/questions/47671108/docker-php-ext-install-mcrypt-missing-folder
RUN pecl install mcrypt
RUN docker-php-ext-enable mcrypt

RUN docker-php-ext-install -j$(nproc) iconv mysqli
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

COPY config/php.ini /usr/local/etc/php/
