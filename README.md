# PHP-FPM 7.1-DEV Docker
PHP-FPM 7.1 use **ONLY** for development environment

**Good for the latest stable version of symfony**

[![Build Status](https://travis-ci.org/feries/docker-php7.1-fpm-dev.svg?branch=master)](https://travis-ci.org/feries/docker-php7.1-fpm-dev)
[![](https://images.microbadger.com/badges/image/feries/php7.1.svg)](https://microbadger.com/images/feries/php7.1 "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/feries/php7.1.svg)](https://microbadger.com/images/feries/php7.1 "Get your own version badge on microbadger.com")

*Based on **[php:7.1-fpm](https://github.com/docker-library/php/blob/master/7.1/Dockerfile)***

## Services

- **PHP-FPM 7.1x** (on *port 9001*)
    - **APCu** - APC User Cache
    - **OPcache**
    - PHP extension for interfacing with **Redis** (with php session.save_handler pre-configurated with tcp://redis-session:6379)
    - **PHP Intl** extension with **Icu** 59.1
    - **PHP pdo/pdo_mysql** extension 
- **Xdebug** 2.5.5 (on *port 9000*)
- **Composer**
- **Symfony bin**
- **GIT**
- **ZSH** (with *oh-my-zsh*) shell

***

### Xdebug

Preconfigurated with this arg

    ARG XDEBUG_KEY="PHPSTORM"
    ARG XDEBUG_REMOTE_IP="10.254.254.254"
    ARG XDEBUG_REMOTE_PORT="9000"
 
#### Xdebug with macOS host (Docker for Mac)

Add new alias loopback for localhost

    sudo ifconfig lo0 alias 10.254.254.254 netmask 255.255.255.0

#### Xdebug with Linux host

Add new alias loopback for localhost

Append to file `/etc/network/interfaces`


    auto lo:0
    iface lo:0 inet static
    name Docker loopback
    address 10.254.254.254
    netmask 255.255.255.0

***

### Redis (session handler)

If you use this docker with compose, simply add this service to your docker-compose.yml

      redis-session:
          image: redis:latest
          hostname: redis-session 


*** 

Licensed under a GPL3+ license: http://www.gnu.org/licenses/gpl-3.0.txt