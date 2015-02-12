#!/bin/sh
#
# description: install mysql
#
# author: Lancer He <lancer.he@gmail.com>
#yum install -y gcc gcc-c++ ncurses-devel libtool-ltdl-devel

cd /usr/local/src/

if [ ! -e mysql-proxy-0.8.5.tar.gz ]; then
    echo "Please download mysql-proxy from mysql site."
    exit 0
fi

if [ ! -e glib-2.18.4.tar.gz ]; then
    wget "http://ftp.gnome.org/pub/gnome/sources/glib/2.18/glib-2.18.4.tar.gz"
fi

if [ ! -e readline-6.1.tar.gz ]; then
    wget "ftp://ftp.cwru.edu/pub/bash/readline-6.1.tar.gz"
fi

if [ ! -e lua-5.1.4.tar.gz ]; then
    wget "http://www.lua.org/ftp/lua-5.1.4.tar.gz"
fi

tar xvf glib-2.18.4.tar.gz
cd glib-2.18.4
./configure
make && make install
cd ..
rm -rf glib-2.18.4

tar xvf readline-6.1.tar.gz
cd readline-6.1
./configure
make && make install
cd ..
rm -rf readline-6.1

ldconfig -v

tar xvf lua-5.1.4.tar.gz
cd lua-5.1.4
sed -i '11s/^.*$/CFLAGS= -O2 -Wall -fPIC \$(MYCFLAGS)/g' src/Makefile
make linux  
make install
cp etc/lua.pc /usr/local/lib/pkgconfig/   
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig 
cd ..
rm -rf lua-5.1.4

tar xvf mysql-proxy-0.8.5.tar.gz
cd mysql-proxy-0.8.5
./configure --prefix=/usr/local/mysql-proxy-0.8.5
make && make install
cp lib/rw-splitting.lua /usr/local/lib/
cp lib/admin.lua /usr/local/lib/
cd ..
rm -rf mysql-proxy-0.8.5

echo "
[mysql-proxy]
daemon=false
proxy-backend-addresses=127.0.0.1:3306
proxy-address=0.0.0.0:4040
proxy-lua-script=/data/vhosts/alter.lua
log-file=/var/log/mysql-proxy.log
log-level=debug
keepalive=true
" > /etc/mysql-proxy.cnf
chmod 0660 /etc/mysql-proxy.cnf

echo "Server start: /usr/local/mysql-proxy-0.8.5/bin/mysql-proxy --defaults-file=/etc/mysql-proxy.cnf"
echo "Install mysql-proxy successfully."
