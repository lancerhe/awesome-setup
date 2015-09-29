#!/bin/sh
#
# description: install php
#
# author: Lancer He <lancer.he@gmail.com>

PHP_VERSION="5.4.44"
if [ ! -d /usr/local/src/phpext ]; then
    mkdir -p /usr/local/src/phpext
fi
cd /usr/local/src/phpext

# Make extension folder
if [ ! -d /usr/local/php-${PHP_VERSION}/etc/ext/ ]; then
    mkdir -p /usr/local/php-${PHP_VERSION}/etc/ext/
fi


# ++++++++++++++++++++++ Yaf ++++++++++++++++++++++
if [ ! -f yaf-2.3.3.tgz ]; then
    wget http://pecl.php.net/get/yaf-2.3.3.tgz
fi
tar zxf yaf-2.3.3.tgz
cd yaf-2.3.3 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf yaf-2.3.3

echo '[yaf]
extension            = yaf.so
yaf.environ          = local
yaf.cache_config     = 0
yaf.name_suffix      = 0
yaf.name_separator   = "_"
yaf.forward_limit    = 5
yaf.use_namespace    = 1
yaf.use_spl_autoload = 1
yaf.lowcase_path     = 1
' > /usr/local/php-${PHP_VERSION}/etc/ext/yaf.ini


# ++++++++++++++++++++++ Yar ++++++++++++++++++++++
if [ ! -f yar-1.2.4.tgz ]; then
    wget http://pecl.php.net/get/yar-1.2.4.tgz
fi
tar zxf yar-1.2.4.tgz
cd yar-1.2.4 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf yar-1.2.4

echo '[yar]
extension = yar.so
' > /usr/local/php-${PHP_VERSION}/etc/ext/yar.ini


# ++++++++++++++++++++++ Yac ++++++++++++++++++++++
if [ ! -f yac-0.9.2.tgz ]; then
    wget http://pecl.php.net/get/yac-0.9.2.tgz
fi
tar zxf yac-0.9.2.tgz
cd yac-0.9.2 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf yac-0.9.2

echo '[yac]
extension = yac.so
yac.enable = 1
yac.keys_memory_size = 4M ; 4M can get 30K key slots, 32M can get 100K key slots
yac.values_memory_size = 64M
yac.compress_threshold = -1
yac.enable_cli = 0 ; whether enable yac with cli, default 0
' > /usr/local/php-${PHP_VERSION}/etc/ext/yac.ini


# ++++++++++++++++++++++ zendopcache ++++++++++++++++++++++
if [ ! -f zendopcache-7.0.5.tgz ]; then
    wget http://pecl.php.net/get/zendopcache-7.0.5.tgz
fi
tar zxvf zendopcache-7.0.5.tgz 
cd zendopcache-7.0.5 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf zendopcache-7.0.5

echo "[opcache]
zend_extension = /usr/local/php-${PHP_VERSION}/lib/php/extensions/no-debug-zts-20100525/opcache.so
opcache.memory_consumption      = 128
opcache.interned_strings_buffer = 8
opcache.max_accelerated_files   = 4000
opcache.revalidate_freq         = 60
opcache.fast_shutdown           = 1
opcache.enable_cli              = 1
" > /usr/local/php-${PHP_VERSION}/etc/ext/opcache.ini


# ++++++++++++++++++++++ memcache ++++++++++++++++++++++
if [ ! -f memcache-3.0.8.tgz ]; then
    wget http://pecl.php.net/get/memcache-3.0.8.tgz
fi
tar zxf memcache-3.0.8.tgz
cd memcache-3.0.8 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf memcache-3.0.8

echo '[memcache]
extension = memcache.so
' > /usr/local/php-${PHP_VERSION}/etc/ext/memcache.ini


# ++++++++++++++++++++++ mongo ++++++++++++++++++++++
if [ ! -f mongo-1.3.6.tgz ]; then
    wget http://pecl.php.net/get/mongo-1.3.6.tgz
fi
tar zxf mongo-1.3.6.tgz
cd mongo-1.3.6 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf mongo-1.3.6

echo '[mongo]
extension = mongo.so
' > /usr/local/php-${PHP_VERSION}/etc/ext/mongo.ini


# ++++++++++++++++++++++ redis ++++++++++++++++++++++
if [ ! -f redis-2.2.5.tgz ]; then
    wget http://pecl.php.net/get/redis-2.2.5.tgz
fi
tar zxf redis-2.2.5.tgz
cd redis-2.2.5 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf redis-2.2.5

echo '[redis]
extension = redis.so
' > /usr/local/php-${PHP_VERSION}/etc/ext/redis.ini

# ++++++++++++++++++++++ swoole ++++++++++++++++++++++
if [ ! -f swoole-1.7.18.tgz ]; then
    wget http://pecl.php.net/get/swoole-1.7.18.tgz
fi
tar zxf swoole-1.7.18.tgz
cd swoole-1.7.18 && /usr/local/php-${PHP_VERSION}/bin/phpize && ./configure --with-php-config=/usr/local/php-${PHP_VERSION}/bin/php-config && make && make install
cd .. && rm -rf swoole-1.7.18

echo '[swoole]
extension = swoole.so
' > /usr/local/php-${PHP_VERSION}/etc/ext/swoole.ini

rm -f package2.xml
rm -f package.xml

/etc/init.d/php-fpm restart
/usr/local/php-${PHP_VERSION}/bin/php --ini