#!/bin/sh
#
# description: install php
#
# author: Lancer He <lancer.he@gmail.com>

yum install -y gcc gcc-c++ libxml2-devel bzip2-devel curl-devel libjpeg-devel libpng-devel libtiff-devel freetype-devel
cd /usr/local/src/
if [ ! -e php-5.4.33.tar.gz ]; then
    wget http://cn2.php.net/distributions/php-5.4.33.tar.gz
fi

if [ ! -e libmcrypt-2.5.8.tar.gz ]; then
    wget http://softlayer.dl.sourceforge.net/sourceforge/mcrypt/libmcrypt-2.5.8.tar.gz
fi

tar zxf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure --prefix=/usr/local/libmcrypt-2.5.8
make -j 4
make install
cd ..
rm -rf libmcrypt-2.5.8

tar zxf php-5.4.33.tar.gz
cd php-5.4.33
./configure \
    --prefix=/usr/local/php-5.4.33 \
    --with-pear \
    --with-zlib-dir \
    --with-bz2 \
    --with-libxml-dir=/usr \
    --with-gd \
    --enable-gd-native-ttf \
    --enable-gd-jis-conv \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --enable-mbstring \
    --with-mysql \
    --with-mysqli \
    --with-pdo_mysql \
    --with-config-file-path=/usr/local/php-5.4.33/etc \
    --with-config-file-scan-dir=/usr/local/php-5.4.33/etc/ext \
    --with-iconv \
    --disable-ipv6 \
    --enable-static \
    --enable-inline-optimization \
    --enable-sockets \
    --enable-soap \
    --with-openssl \
    --with-gettext \
    --with-curl \
    --enable-fpm \
    --enable-ftp \
    --enable-shmop \
    --with-mcrypt=/usr/local/libmcrypt-2.5.8

make -j 4
make install
cp php.ini-development /usr/local/php-5.4.33/etc/php.ini
cp php.ini-development /usr/local/php-5.4.33/etc/
cp php.ini-production /usr/local/php-5.4.33/etc/
cd ..
rm -rf php-5.4.33

echo 'pid = /usr/local/php-5.4.33/var/run/php-fpm.pid
error_log = /usr/local/php-5.4.33/var/log/php-fpm.log
log_level = error
[www]
listen = 127.0.0.1:9000
user = nobody
group = nobody
pm = static
pm.max_children = 10
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 10
pm.max_requests = 5120
slowlog = /usr/local/php-5.4.33/var/log/php-fpm.log.slow
rlimit_files = 51200
' > /usr/local/php-5.4.33/etc/php-fpm.conf

echo '#! /bin/sh

### BEGIN INIT INFO
# Provides:          php-fpm
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts php-fpm
# Description:       starts the PHP FastCGI Process Manager daemon
### END INIT INFO

php_fpm_BIN=/usr/local/php-5.4.33/sbin/php-fpm
php_fpm_CONF=/usr/local/php-5.4.33/etc/php-fpm.conf
php_fpm_PID=/usr/local/php-5.4.33/var/run/php-fpm.pid

php_opts="--fpm-config $php_fpm_CONF"

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
' > /etc/init.d/php-fpm 

chmod +x /etc/init.d/php-fpm 
/etc/init.d/php-fpm start
/etc/init.d/php-fpm stop

echo "Install php 5.4.33 successfully."