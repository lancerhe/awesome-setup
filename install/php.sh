#!/bin/bash
#
# description: install php
#
# author: Lancer He <lancer.he@gmail.com>

yum install -y tar wget gcc gcc-c++ libxml2-devel bzip2-devel curl-devel libjpeg-devel libpng-devel libtiff-devel freetype-devel openssl openssl-devel libc-client-devel libxslt-devel

PHP_VERSION="5.4.44"
WORKER_USER="work"
cd /usr/local/src/
if [ ! -e php-${PHP_VERSION}.tar.gz ]; then
    wget http://cn2.php.net/distributions/php-${PHP_VERSION}.tar.gz
fi

if [ ! -e libmcrypt-2.5.8.tar.gz ]; then
    wget http://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz/download -O libmcrypt-2.5.8.tar.gz
fi

if [ ! -d /usr/local/libmcrypt-2.5.8 ]; then
    tar zxf libmcrypt-2.5.8.tar.gz
    cd libmcrypt-2.5.8 && ./configure --prefix=/usr/local/libmcrypt-2.5.8 && make -j 4 && make install
    cd .. && rm -rf libmcrypt-2.5.8
fi


tar zxf php-${PHP_VERSION}.tar.gz
cd php-${PHP_VERSION}
# --with-apxs2=/usr/local/apache2/bin/apxs \
./configure \
    --prefix=/usr/local/php-${PHP_VERSION} \
    --with-bz2 \
    --with-zlib \
    --with-zlib-dir \
    --with-libxml-dir= \
    --enable-calendar \
    --enable-ftp \
    --with-gd \
    --with-jpeg-dir \
    --with-png-dir \
    --with-freetype-dir \
    --enable-gd-native-ttf \
    --enable-mbstring \
    --with-mysql \
    --with-mysqli \
    --with-mysql-sock \
    --with-pdo-mysql \
    --enable-sockets \
    --with-xsl \
    --enable-zip \
    --enable-bcmath \
    --with-curl=/usr \
    --with-openssl \
    --enable-fpm \
    --with-iconv \
    --enable-soap \
    --with-config-file-path=/usr/local/php-${PHP_VERSION}/etc  \
    --with-config-file-scan-dir=/usr/local/php-${PHP_VERSION}/etc/ext \
    --with-mcrypt=/usr/local/libmcrypt-2.5.8 \
    --with-imap \
    --with-kerberos  \
    --with-imap-ssl \
    --disable-fileinfo

make -j 4
make install
cp php.ini-development /usr/local/php-${PHP_VERSION}/etc/php.ini
cp php.ini-development /usr/local/php-${PHP_VERSION}/etc/
cp php.ini-production /usr/local/php-${PHP_VERSION}/etc/
touch /usr/local/php-${PHP_VERSION}/var/log/php-fpm.log
touch /usr/local/php-${PHP_VERSION}/var/log/php-fpm.log.slow
touch /usr/local/php-${PHP_VERSION}/var/log/php-error.log
chown ${WORKER_USER}.${WORKER_USER} /usr/local/php-${PHP_VERSION}/var/log/php-error.log
chmod 644 /usr/local/php-${PHP_VERSION}/var/log/php-fpm.log.slow
chmod 644 /usr/local/php-${PHP_VERSION}/var/log/php-fpm.log
cd .. && rm -rf php-${PHP_VERSION}

# Add ini.
echo "error_log = /usr/local/php-${PHP_VERSION}/var/log/php-error.log
date.timezone = Asia/Shanghai
" >> /usr/local/php-${PHP_VERSION}/etc/php.ini

# Add fpm config.
echo "pid = /usr/local/php-${PHP_VERSION}/var/run/php-fpm.pid
error_log = /usr/local/php-${PHP_VERSION}/var/log/php-fpm.log
log_level = error
[www]
listen = 127.0.0.1:9000
user = ${WORKER_USER}
group = ${WORKER_USER}
pm = static
pm.max_children = 10
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 10
pm.max_requests = 1024
slowlog = /usr/local/php-${PHP_VERSION}/var/log/php-fpm.log.slow
rlimit_files = 1024
request_slowlog_timeout = 5
" > /usr/local/php-${PHP_VERSION}/etc/php-fpm.conf

echo "#! /bin/sh
### BEGIN INIT INFO
# Provides:          php-fpm
# Required-Start:    \$all
# Required-Stop:     \$all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts php-fpm
# Description:       starts the PHP FastCGI Process Manager daemon
### END INIT INFO
php_fpm_BIN=/usr/local/php-${PHP_VERSION}/sbin/php-fpm
php_fpm_CONF=/usr/local/php-${PHP_VERSION}/etc/php-fpm.conf
php_fpm_PID=/usr/local/php-${PHP_VERSION}/var/run/php-fpm.pid
" > /etc/init.d/php-fpm
echo 'php_opts="--fpm-config $php_fpm_CONF"
wait_for_pid () {
    try=0
    while test $try -lt 35 ; do
        case "$1" in
            "created")
            if [ -f "$2" ] ; then
                try=''
                break
            fi
            ;;
            "removed")
            if [ ! -f "$2" ] ; then
                try=''
                break
            fi
            ;;
        esac
        echo -n .
        try=`expr $try + 1`
        sleep 1
    done
}
case "$1" in
    start)
        echo -n "Starting php-fpm "
        $php_fpm_BIN $php_opts --pid $php_fpm_PID
        if [ "$?" != 0 ] ; then
            echo " failed"
            exit 1
        fi
        wait_for_pid created $php_fpm_PID
        if [ -n "$try" ] ; then
            echo " failed"
            exit 1
        else
            echo " done"
        fi
    ;;
    stop)
        echo -n "Gracefully shutting down php-fpm "
        if [ ! -r $php_fpm_PID ] ; then
            echo "warning, no pid file found - php-fpm is not running ?"
            exit 1
        fi
        kill -QUIT `cat $php_fpm_PID`
        wait_for_pid removed $php_fpm_PID
        if [ -n "$try" ] ; then
            echo " failed. Use force-exit"
            exit 1
        else
            echo " done"
        fi
    ;;
    force-quit)
        echo -n "Terminating php-fpm "
        if [ ! -r $php_fpm_PID ] ; then
            echo "warning, no pid file found - php-fpm is not running ?"
            exit 1
        fi
        kill -TERM `cat $php_fpm_PID`
        wait_for_pid removed $php_fpm_PID
        if [ -n "$try" ] ; then
            echo " failed"
            exit 1
        else
            echo " done"
        fi
    ;;
    restart)
        $0 stop
        $0 start
    ;;
    reload)
        echo -n "Reload service php-fpm "
        if [ ! -r $php_fpm_PID ] ; then
            echo "warning, no pid file found - php-fpm is not running ?"
            exit 1
        fi
        kill -USR2 `cat $php_fpm_PID`
        echo " done"
    ;;
    *)
       echo "Usage: $0 {start|stop|force-quit|restart|reload}"
       exit 1
    ;;
esac
' >> /etc/init.d/php-fpm

chmod +x /etc/init.d/php-fpm 
/etc/init.d/php-fpm start
/etc/init.d/php-fpm stop

echo "Install php $PHP_VERSION successfully."