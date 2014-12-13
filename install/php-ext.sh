#!/bin/sh
#
# description: install php
#
# author: Lancer He <lancer.he@gmail.com>
if [ ! -d /usr/local/src/phpext ]; then
    mkdir -p /usr/local/src/phpext
fi
cd /usr/local/src/phpext

# Make extension folder
if [ ! -d /usr/local/php-5.4.33/etc/ext/ ]; then
    mkdir -p /usr/local/php-5.4.33/etc/ext/
fi


# ++++++++++++++++++++++ Yaf ++++++++++++++++++++++
if [ ! -f yaf-2.3.3.tgz ]; then
    wget http://pecl.php.net/get/yaf-2.3.3.tgz
fi
tar zxf yaf-2.3.3.tgz
cd yaf-2.3.3
/usr/local/php-5.4.33/bin/phpize && ./configure --with-php-config=/usr/local/php-5.4.33/bin/php-config && make && make install
cd .. && rm -rf yaf-2.3.3

echo '[yaf]
extension = yaf.so
yaf.environ=local
yaf.cache_config=0
yaf.name_suffix=0
yaf.name_separator="_"
yaf.forward_limit=5
yaf.use_namespace=1
yaf.use_spl_autoload=1
yaf.lowcase_path=1
' > /usr/local/php-5.4.33/etc/ext/yaf.ini


# ++++++++++++++++++++++ Yar ++++++++++++++++++++++
if [ ! -f yar-1.2.4.tgz ]; then
    wget http://pecl.php.net/get/yar-1.2.4.tgz
fi
tar zxf yar-1.2.4.tgz
cd yar-1.2.4
/usr/local/php-5.4.33/bin/phpize && ./configure --with-php-config=/usr/local/php-5.4.33/bin/php-config && make && make install
cd .. && rm -rf yar-1.2.4

echo '[yar]
extension = yar.so
' > /usr/local/php-5.4.33/etc/ext/yar.ini


# ++++++++++++++++++++++ Yac ++++++++++++++++++++++
if [ ! -f yac-0.9.2.tgz ]; then
    wget http://pecl.php.net/get/yac-0.9.2.tgz
fi
tar zxf yac-0.9.2.tgz
cd yac-0.9.2
/usr/local/php-5.4.33/bin/phpize && ./configure --with-php-config=/usr/local/php-5.4.33/bin/php-config && make && make install
cd .. && rm -rf yac-0.9.2

echo '[yac]
extension = yac.so
yac.enable = 1
yac.keys_memory_size = 4M ; 4M can get 30K key slots, 32M can get 100K key slots
yac.values_memory_size = 64M
yac.compress_threshold = -1
yac.enable_cli = 0 ; whether enable yac with cli, default 0
' > /usr/local/php-5.4.33/etc/ext/yac.ini


# ++++++++++++++++++++++ eaccelerator ++++++++++++++++++++++
if [ ! -f eaccelerator.tar.gz ]; then
    wget https://github.com/eaccelerator/eaccelerator/tarball/master -O eaccelerator.tar.gz
fi
tar zxvf eaccelerator.tar.gz 
cd eaccelerator-eaccelerator-42067ac/
/usr/local/php-5.4.33/bin/phpize && ./configure --enable-eaccelerator=shared --with-php-config=/usr/local/php-5.4.33/bin/php-config && make && make install
cd .. && rm -rf eaccelerator-eaccelerator-42067ac

echo '[eaccelerator]
extension = eaccelerator.so
eaccelerator.shm_size="256"
eaccelerator.cache_dir="/tmp/php5.4.33-eaccelerator"
eaccelerator.enable="1"
eaccelerator.optimizer="1"
eaccelerator.check_mtime="1"
eaccelerator.debug="0"
eaccelerator.filter=""
eaccelerator.shm_max="0"
eaccelerator.shm_ttl="0"
eaccelerator.shm_prune_period="0"
eaccelerator.shm_only="0"
eaccelerator.compress="1"
eaccelerator.compress_level="9"
' > /usr/local/php-5.4.33/etc/ext/eaccelerator.ini


# ++++++++++++++++++++++ memcache ++++++++++++++++++++++
if [ ! -f memcache-3.0.8.tgz ]; then
    wget http://pecl.php.net/get/memcache-3.0.8.tgz
fi
tar zxf memcache-3.0.8.tgz
cd memcache-3.0.8
/usr/local/php-5.4.33/bin/phpize && ./configure --with-php-config=/usr/local/php-5.4.33/bin/php-config && make && make install
cd .. && rm -rf memcache-3.0.8

echo '[memcache]
extension = memcache.so
' > /usr/local/php-5.4.33/etc/ext/memcache.ini


# ++++++++++++++++++++++ mongo ++++++++++++++++++++++
if [ ! -f mongo-1.3.6.tgz ]; then
    wget http://pecl.php.net/get/mongo-1.3.6.tgz
fi
tar zxf mongo-1.3.6.tgz
cd mongo-1.3.6
/usr/local/php-5.4.33/bin/phpize && ./configure --with-php-config=/usr/local/php-5.4.33/bin/php-config && make && make install
cd .. && rm -rf mongo-1.3.6

echo '[mongo]
extension = mongo.so
' > /usr/local/php-5.4.33/etc/ext/mongo.ini


# ++++++++++++++++++++++ redis ++++++++++++++++++++++
if [ ! -f redis-2.2.5.tgz ]; then
    wget http://pecl.php.net/get/redis-2.2.5.tgz
fi
tar zxf redis-2.2.5.tgz
cd redis-2.2.5
/usr/local/php-5.4.33/bin/phpize && ./configure --with-php-config=/usr/local/php-5.4.33/bin/php-config && make && make install
cd .. && rm -rf redis-2.2.5

echo '[redis]
extension = redis.so
' > /usr/local/php-5.4.33/etc/ext/redis.ini


# ++++++++++++++++++++++ ZendGuardLoader ++++++++++++++++++++++
if [ `uname -i` = 'i386' ]; then
    if [ ! -f ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz ]; then
        wget http://downloads.zend.com/guard/6.0.0/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
    fi
    tar zxf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
    cp ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386/php-5.4.x/ZendGuardLoader.so /usr/local/php-5.4.33/lib/php/extensions/no-debug-non-zts-20100525/
    rm -rf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386
else
    if [ ! -f ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz ]; then
        wget http://downloads.zend.com/guard/6.0.0/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
    fi
    tar zxf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
    cp ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64/php-5.4.x/ZendGuardLoader.so /usr/local/php-5.4.33/lib/php/extensions/no-debug-non-zts-20100525/
    rm -rf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64
fi

echo '[Zend]
zend_extension=/usr/local/php-5.4.33/lib/php/extensions/no-debug-non-zts-20100525/ZendGuardLoader.so
zend_loader.enable=1
zend_loader.disable_licensing=0
zend_loader.obfuscation_level_support=3
' > /usr/local/php-5.4.33/etc/ext/zend.ini


# ++++++++++++++++++++++ xdebug ++++++++++++++++++++++
if [ ! -f xdebug-2.2.3.tgz ]; then
    wget http://www.xdebug.com/files/xdebug-2.2.3.tgz
fi
tar zxf xdebug-2.2.3.tgz
cd xdebug-2.2.3
/usr/local/php-5.4.33/bin/phpize && ./configure --enable-xdebug --with-php-config=/usr/local/php-5.4.33/bin/php-config && make && make install
cd .. && rm -rf xdebug-2.2.3

echo '[xdebug]
zend_extension=/usr/local/php-5.4.33/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so
xdebug.auto_trace=on
xdebug.collect_params=on
xdebug.collect_return=on
xdebug.trace_output_dir="/tmp/php-5.4.33-xdebug"
xdebug.profiler_enable=on
xdebug.profiler_output_dir="/tmp/php-5.4.33-xdebug"
' > /usr/local/php-5.4.33/etc/ext/xdebug.ini

rm -f package2.xml
rm -f package.xml

/etc/init.d/php-fpm restart
/usr/local/php-5.4.33/bin/php --ini