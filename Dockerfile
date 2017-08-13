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
  # just to be certain things are cleaned up
  && rm -rf /tmp/icu*

# PHP_CPPFLAGS are used by the docker-php-ext-* scripts
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

RUN docker-php-ext-configure intl --with-icu-dir=/usr/local \
  # run configure and install in the same RUN line, they extract and clean up the php source to save space
  && docker-php-ext-install intl

# Update system
#RUN apt-get -y upgrade

# Install Xdebug
RUN pecl install xdebug-2.5.5
RUN pecl install apcu
RUN docker-php-ext-enable apcu opcache xdebug

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clean Apt
RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Timezone configuration (For Symfony compatibility)
RUN echo 'date.timezone="Europe/Rome"' >> /usr/local/etc/php/php.ini
RUN echo 'short_open_tag=off' >> /usr/local/etc/php/php.ini

# Zsh
RUN bash -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -q -O -)"
RUN chsh -s /bin/zsh

RUN usermod -u 1000 www-data
#RUN chown -R www-data:www-data /var/www/app/cache
#RUN chown -R www-data:www-data /var/www/app/logs

WORKDIR /var/www