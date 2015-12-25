#!/bin/sh
#
# description: install mysql
#
# author: Lancer He <lancer.he@gmail.com>
yum -y install make gcc-c++ cmake bison-devel ncurses-devel
cd /usr/local/src/
if [ ! -e mysql-5.6.14.tar.gz ]; then
    wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.14.tar.gz
fi

groupadd mysql
useradd -g mysql mysql

if [ ! -f /data/mysql ]; then
    mkdir -p /data/mysql-5.6.14
    chown -R mysql:mysql /data/mysql-5.6.14
fi

tar zxvf mysql-5.6.14.tar.gz
cd mysql-5.6.14
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.6.14 \
    -DMYSQL_UNIX_ADDR=/usr/local/mysql-5.6.14/var/mysql.sock \
    -DMYSQL_DATADIR=/data/mysql-5.6.14 \
    -DSYSCONFDIR=/usr/local/mysql-5.6.14/my.cnf \
    -DMYSQL_USER=mysql \
    -DMYSQL_TCP_PORT=3306 \
    -DEXTRA_CHARSETS=all \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITH_MEMORY_STORAGE_ENGINE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DWITH_READLINE=1 \
    -DENABLED_LOCAL_INFILE=1

make -j 8
make install

mkdir /usr/local/mysql-5.6.14/var/
mkdir /usr/local/mysql-5.6.14/var/log/
chown -R mysql:mysql /usr/local/mysql-5.6.14/var/
/usr/local/mysql-5.6.14/scripts/mysql_install_db --basedir=/usr/local/mysql-5.6.14 --datadir=/data/mysql-5.6.14 --user=mysql

cp support-files/mysql.server /etc/init.d/mysql.server
chmod +x /etc/init.d/mysql.server

cd ..
rm -rf mysql-5.6.14

/etc/init.d/mysql.server start
netstat -an | grep LISTEN | grep 3306
chkconfig --add mysql.server

echo "export PATH=$PATH:/usr/local/mysql-5.6.14/bin/" >> /etc/profile
source /etc/profile

echo "Install mysql 5.1.70 successfully, setup mysql: /usr/local/mysql-5.6.14/bin/mysql_secure_installation"
