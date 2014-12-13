#!/bin/sh
#
# description: install mongodb
#
# author: Lancer He <lancer.he@gmail.com>

cd /usr/local/src/
if [ ! -e mongodb-linux-i686-2.4.1.tgz ]; then
    wget http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.4.1.tgz
fi

tar zxf mongodb-linux-i686-2.4.1.tgz
mv mongodb-linux-i686-2.4.1 /usr/local/mongodb-2.4.1

if [ ! -d /data/mongodb ]; then
    mkdir /data/mongodb
fi

if [ ! -d /usr/local/mongodb-2.4.1/var/log ]; then
    mkdir -p /usr/local/mongodb-2.4.1/var/log
fi

echo '#!/bin/bash
#
# mongodb     Startup script for the mongodb server
#
# chkconfig: - 64 36
# description: MongoDB Database Server
#
# processname: mongodb

# Source function library
. /etc/rc.d/init.d/functions

if [ -f /etc/sysconfig/mongodb ]; then
    . /etc/sysconfig/mongodb
fi

prog="mongod"
mongod="/usr/local/mongodb-2.4.1/bin/mongod"
RETVAL=0

start() {
    echo -n $"Starting $prog: "
    daemon $mongod "--dbpath=/data/mongodb/ --port=27017 --fork --logpath /usr/local/mongodb-2.4.1/var/log/mongodb.log --logappend 2>&1 >> /usr/local/mongodb-2.4.1/var/log/mongodb.log"
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch /var/lock/subsys/$prog
    return $RETVAL
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $prog
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/$prog
    return $RETVAL
}

reload() {
    echo -n $"Reloading $prog: "
    killproc $prog -HUP
    RETVAL=$?
    echo
    return $RETVAL
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    condrestart)
        if [ -f /var/lock/subsys/$prog ]; then
            stop
            start
        fi
        ;;
    reload)
        reload
        ;;
    status)
        status $mongod
        RETVAL=$?
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|condrestart|reload|status}"
        RETVAL=1
esac

exit $RETVAL
' > /etc/init.d/mongod
chmod +x /etc/init.d/mongod
/etc/init.d/mongod start
/etc/init.d/mongod stop

echo "Install mongod 2.4.1 successfully."