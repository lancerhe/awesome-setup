#!/bin/sh
#
# description: install mysql
#
# author: Lancer He <lancer.he@gmail.com>
yum -y install make gcc-c++ cmake bison-devel ncurses-devel
cd /usr/local/src/
if [ ! -e mysql-5.7.17.tar.gz ]; then
    wget http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.17.tar.gz
fi

groupadd mysql
useradd -g mysql mysql

if [ ! -f /data/mysql ]; then
    mkdir -p /data/mysql-5.7.17
    chown -R mysql:mysql /data/mysql-5.7.17
fi

tar zxvf mysql-5.7.17.tar.gz
cd mysql-5.7.17
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.7.17 \
    -DMYSQL_UNIX_ADDR=/usr/local/mysql-5.7.17/var/mysql.sock \
    -DMYSQL_DATADIR=/data/mysql-5.7.17 \
    -DSYSCONFDIR=/usr/local/mysql-5.7.17/my.cnf \
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
    -DDOWNLOAD_BOOST=1 \
    -DWITH_BOOST=/usr/local/boost \
    -DENABLED_LOCAL_INFILE=1

make -j 8
make install

mkdir /usr/local/mysql-5.7.17/var/
mkdir /usr/local/mysql-5.7.17/var/log/
mkdir /usr/local/mysql-5.7.17/var/run/
chown -R mysql:mysql /usr/local/mysql-5.7.17/var/
/usr/local/mysql-5.7.17/scripts/mysql_install_db --basedir=/usr/local/mysql-5.7.17 --datadir=/data/mysql-5.7.17 --user=mysql

rm -f /etc/my.cnf
cp support-files/mysql.server /etc/init.d/mysql.server
chmod +x /etc/init.d/mysql.server
mv /usr/local/mysql-5.7.17/my.cnf /usr/local/mysql-5.7.17/my.cnf.development
echo '[mysqld]
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
datadir=/data/mysql-5.7.17
socket=/usr/local/mysql-5.7.17/var/mysql.sock
user=mysql
[mysqld_safe]
log-error=/usr/local/mysql-5.7.17/var/log/mysqld.log
pid-file=/usr/local/mysql-5.7.17/var/run/mysqld.pid' > /usr/local/mysql-5.7.17/my.cnf
cd ..
rm -rf mysql-5.7.17

/etc/init.d/mysql.server start
netstat -an | grep LISTEN | grep 3306
chkconfig --add mysql.server

echo "export PATH=$PATH:/usr/local/mysql-5.7.17/bin/" >> /etc/profile
source /etc/profile

echo "Install mysql 5.1.70 successfully, setup mysql: /usr/local/mysql-5.7.17/bin/mysql_secure_installation"
