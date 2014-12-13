#!/bin/sh
#
# description: install redis
#
# author: Lancer He <lancer.he@gmail.com>

yum install -y gcc gcc-c++
cd /usr/local/src/
if [ ! -e redis-2.8.2.tar.gz ]; then
    wget http://download.redis.io/releases/redis-2.8.2.tar.gz
fi

tar zxf redis-2.8.2.tar.gz
rm -rf /usr/local/redis-2.8.2
mv redis-2.8.2 /usr/local/redis-2.8.2
cd /usr/local/redis-2.8.2/src
make -j 4
# make test

if [ ! -f /usr/local/redis-2.8.2/var/run ]; then
    mkdir -p /usr/local/redis-2.8.2/var/run
fi

sed -i "s/daemonize no/daemonize yes/g" /usr/local/redis-2.8.2/redis.conf

echo '#!/bin/bash 
# 
# Init file for redis 
# 
# chkconfig: - 80 12 
# description: redis daemon 
# 
# processname: redis 
# config: /etc/redis.conf 
source /etc/init.d/functions
BIN="/usr/local/redis-2.8.2/src"
CONFIG="/usr/local/redis-2.8.2/redis.conf"
PIDFILE="/usr/local/redis-2.8.2/var/run/redis.pid"
### Read configuration 
[ -r "$SYSCONFIG" ] && source "$SYSCONFIG"
RETVAL=0
prog="redis-server"
desc="Redis Server"
start() {
    if [ -e $PIDFILE ];then
        echo "$desc already running...." 
        exit 1
    fi
    echo -n $"Starting $desc: " 
    daemon $BIN/$prog $CONFIG
    RETVAL=$?
    echo 
    [ $RETVAL -eq 0 ] && touch /var/lock/subsys/$prog
    return $RETVAL
}
stop() {
    echo -n $"Stop $desc: " 
    killproc $prog
    RETVAL=$?
    echo 
    [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/$prog $PIDFILE
    return $RETVAL
}
restart() {
    stop
    start
}
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    condrestart)
        [ -e /var/lock/subsys/$prog ] && restart
        RETVAL=$?
        ;;
    status)
        status $prog
        RETVAL=$?
        ;;
   *)
        echo $"Usage: $0 {start|stop|restart|condrestart|status}" 
        RETVAL=1
esac
exit $RETVAL
' > /etc/init.d/redis
chmod +x /etc/init.d/redis
/etc/init.d/redis start
/etc/init.d/redis stop

echo "Install redis 2.8.2 successfully."