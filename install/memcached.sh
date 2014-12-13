#!/bin/sh
#
# description: install memcached
#
# author: Lancer He <lancer.he@gmail.com>

yum install -y gcc libevent-devel
cd /usr/local/src/
if [ ! -e memcached-1.4.15.tar.gz ]; then
    wget http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz
fi

tar zxf memcached-1.4.15.tar.gz
cd memcached-1.4.15
./configure --with-libevent=/usr/lib --prefix=/usr/local/memcached-1.4.15
make -j 4
make install
cd ..
rm -rf memcached-1.4.15

if [ ! -d /usr/local/memcached-1.4.15/var ]; then
    mkdir /usr/local/memcached-1.4.15/var
fi
echo '#!/bin/sh
#
# memcached:    MemCached Daemon
#
# chkconfig:    - 90 25
# description:  MemCached Daemon
#
# Source function library.
. /etc/rc.d/init.d/functions
. /etc/sysconfig/network

start() {
    echo -n $"Starting memcached: "
    daemon /usr/local/memcached-1.4.15/bin/memcached -d -m 200 -u root -c 256 -P /usr/local/memcached-1.4.15/var/memcached.pid
    echo
}

stop() {
    echo -n $"Shutting down memcached: "
    killproc memcached
    echo
}

[ -f /usr/local/memcached-1.4.15/bin/memcached ] || exit 0

# See how we were called.   
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart|reload)
        stop
        start
        ;;
    condrestart)
        stop
        start
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|reload|condrestart}"  
        exit 1
esac
exit 0
' > /etc/init.d/memcached
chmod +x /etc/init.d/memcached
/etc/init.d/memcached start
/etc/init.d/memcached stop

echo "Install memcached 1.4.15 successfully."