#!/bin/sh
#
# description: install nginx
#
# author: Lancer He <lancer.he@gmail.com>

yum install -y gcc pcre-devel openssl-devel
cd /usr/local/src/
if [ ! -e nginx-1.11.3.tar.gz ]; then
    wget http://nginx.org/download/nginx-1.11.3.tar.gz
fi

tar zxf nginx-1.11.3.tar.gz
cd nginx-1.11.3
./configure --prefix=/usr/local/nginx-1.11.3 --with-stream --with-stream_ssl_module --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module
make -j 4
make install
cd ..
rm -rf nginx-1.11.3

echo '#!/bin/sh
#
# memcached:    Nginx Daemon
#
# chkconfig:    - 90 25
# description:  Nginx Daemon
#
# Source function library.
DESC="nginx daemon"
NAME=nginx
DAEMON=/usr/local/nginx-1.11.3/sbin/$NAME
CONFIGFILE=/usr/local/nginx-1.11.3/conf/$NAME.conf
PIDFILE=/usr/local/nginx-1.11.3/logs/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

set -e
[ -x "$DAEMON" ] || exit 0

do_start() {
    $DAEMON -c $CONFIGFILE || echo -n "nginx already running"
}

do_stop() {
    kill -INT `cat $PIDFILE` || echo -n "nginx not running"
}

do_reload() {
    kill -HUP `cat $PIDFILE` || echo -n "nginx can not reload"
}

case "$1" in
    start)
    echo -n "Starting $DESC: $NAME"
    do_start
    echo "."
    ;;
stop)
    echo -n "Stopping $DESC: $NAME"
    do_stop
    echo "."
    ;;
reload|graceful)
    echo -n "Reloading $DESC configuration..."
    do_reload
    echo "."
    ;;
restart)
    echo -n "Restarting $DESC: $NAME"
    do_stop
    do_start
    echo "."
    ;;
*)
    echo "Usage: $SCRIPTNAME {start|stop|reload|restart}" >&2
    exit 3
    ;;
esac
exit 0
' > /etc/init.d/nginx
chmod +x /etc/init.d/nginx
/etc/init.d/nginx start
/etc/init.d/nginx stop

echo "Install nginx 1.11.3 successfully."
