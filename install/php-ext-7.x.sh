#!/bin/sh
#
# description: install php
#
# author: Lancer He <lancer.he@gmail.com>

PHP_VERSION="7.1.8"
if [ ! -d /usr/local/src/phpext ]; then
    mkdir -p /usr/local/src/phpext
fi
cd /usr/local/src/phpext

# Make extension folder
if [ ! -d /usr/local/php-${PHP_VERSION}/etc/ext/ ]; then
    mkdir -p /usr/local/php-${PHP_VERSION}/etc/ext/
fi


# ++++++++++++++++++++++ Yaf ++++++++++++++++++++++
if [ ! -f yaf-3.0.5.tgz ]; then
    wget http://pecl.php.net/get/yaf-3.0.5.tgz
fi
tar zxf yaf-3.0.5.tgz
cd yaf-3.0.5 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf yaf-3.0.5

echo '[yaf]
extension            = yaf.so
yaf.environ          = dev
yaf.cache_config     = 0
yaf.name_suffix      = 0
yaf.name_separator   = "_"
yaf.forward_limit    = 5
yaf.use_namespace    = 1
yaf.use_spl_autoload = 1
yaf.lowcase_path     = 1
' > /usr/local/php-${PHP_VERSION}/etc/ext/yaf.ini


# ++++++++++++++++++++++ Yac ++++++++++++++++++++++
if [ ! -f yac-2.0.2.tgz ]; then
    wget http://pecl.php.net/get/yac-2.0.2.tgz
fi
tar zxf yac-2.0.2.tgz
cd yac-2.0.2 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf yac-2.0.2

echo '[yac]
extension = yac.so
yac.enable = 1
yac.keys_memory_size = 4M ; 4M can get 30K key slots, 32M can get 100K key slots
yac.values_memory_size = 64M
yac.compress_threshold = -1
yac.enable_cli = 0 ; whether enable yac with cli, default 0
' > /usr/local/php-${PHP_VERSION}/etc/ext/yac.ini

# ++++++++++++++++++++++ redis ++++++++++++++++++++++
if [ ! -f redis-3.1.4.tgz ]; then
    wget http://pecl.php.net/get/redis-3.1.4.tgz
fi
tar zxf redis-3.1.4.tgz
cd redis-3.1.4 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf redis-3.1.4

echo '[redis]
extension = redis.so
' > /usr/local/php-${PHP_VERSION}/etc/ext/redis.ini

# ++++++++++++++++++++++ swoole ++++++++++++++++++++++
if [ ! -f swoole-1.9.20.tgz ]; then
    wget http://pecl.php.net/get/swoole-1.9.20.tgz
fi
tar zxf swoole-1.9.20.tgz
cd swoole-1.9.20 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf swoole-1.9.20

echo '[swoole]
extension = swoole.so
' > /usr/local/php-${PHP_VERSION}/etc/ext/swoole.ini


rm -f package2.xml
rm -f package.xml

/etc/init.d/php-fpm restart
/usr/local/php-${PHP_VERSION}/bin/php --ini
