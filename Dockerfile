FROM php:7.1-fpm
MAINTAINER Ramin Banihashemi <a@ramin.it>

ENV DEBIAN_FRONTEND noninteractive

# Install core utilities
RUN apt-get clean && apt-get update && apt-get install -y git-core vim wget zsh libicu-dev

# Install latest Icu for php intl (mininum symfony requirement: icu 59.1)
RUN curl -fsS -o /tmp/icu.tgz -L http://download.icu-project.org/files/icu4c/59.1/icu4c-59_1-src.tgz \
  && tar -zxf /tmp/icu.tgz -C /tmp \
  && cd /tmp/icu/source \
  && ./configure --prefix=/usr/local \
  && make \
  && make install \
  && rm -rf /tmp/icu*

# PHP_CPPFLAGS are used by the docker-php-ext-* scripts
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

# Configure & Install Intl extension
RUN docker-php-ext-configure intl --with-icu-dir=/usr/local && docker-php-ext-install intl

# Install Xdebug
RUN pecl install xdebug-2.5.5
# Install apcu
RUN pecl install apcu
# Install php-redis (to use it as default session handler)
RUN pecl install redis

# Enable php extensions
RUN docker-php-ext-enable apcu opcache xdebug redis

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clean Apt
RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Timezone configuration (For Symfony compatibility)
RUN echo 'date.timezone="Europe/Rome"' >> /usr/local/etc/php/php.ini

# Disable short open tag for php
RUN echo 'short_open_tag=off' >> /usr/local/etc/php/php.ini

# Enable redis extension for php
RUN echo 'extension=redis.so' >> /usr/local/etc/php/php.ini

# Zsh
RUN bash -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -q -O -)"
RUN chsh -s /bin/zsh

RUN usermod -u 1000 www-data

WORKDIR /var/www