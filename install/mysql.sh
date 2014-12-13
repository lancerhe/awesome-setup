#!/bin/sh
#
# description: install mysql
#
# author: Lancer He <lancer.he@gmail.com>
yum install -y gcc gcc-c++ ncurses-devel libtool-ltdl-devel
cd /usr/local/src/
if [ ! -e mysql-5.1.70.tar.gz ]; then
    wget http://downloads.mysql.com/archives/mysql-5.1/mysql-5.1.70.tar.gz
fi

groupadd mysql
useradd -g mysql mysql

if [ ! -f /data/mysql ]; then
    mkdir -p /data/mysql
    chown -R mysql:mysql /data/mysql
fi

tar zxf mysql-5.1.70.tar.gz
cd mysql-5.1.70
    ./configure \
    --prefix=/usr/local/mysql-5.1.70 \
    --with-charset=utf8 \
    --with-collation=utf8_general_ci \
    --with-extra-charsets=complex \
    --with-mysqld-user=mysql \
    --localstatedir=/data/mysql \
    --sysconfdir=/data/mysql \
    --without-docs \
    --without-man \
    --without-test \
    --enable-thread-safe-client \
    --enable-assembler \
    --with-big-tables\
    --with-plugins=partition,heap,myisam,myisammrg,csv,innobase,innodb_plugin

make -j 8
make install

/usr/local/mysql-5.1.70/bin/mysql_install_db --user=mysql
cp support-files/my-small.cnf /etc/my.cnf
cp support-files/mysql.server /etc/init.d/mysqld

cd ..
rm -rf mysql-5.1.70

chmod +x /etc/init.d/mysqld
/etc/init.d/mysqld start
netstat -an | grep LISTEN | grep 3306
chkconfig --add mysqld

echo "Install mysql 5.1.70 successfully."