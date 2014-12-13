#!/bin/sh
#
# description: install svn
#
# author: Lancer He <lancer.he@gmail.com>
yum install -y gcc unzip apr-devel apr-util-devel zlib-devel
cd /usr/local/src/
if [ ! -e subversion-1.8.10.tar.gz ]; then
    wget http://mirrors.cnnic.cn/apache/subversion/subversion-1.8.10.tar.gz
fi
if [ ! -e sqlite-amalgamation-3071501.zip ]; then
    wget http://www.sqlite.org/sqlite-amalgamation-3071501.zip
fi
tar zxf subversion-1.8.10.tar.gz
unzip sqlite-amalgamation-3071501.zip
mv sqlite-amalgamation-3071501 subversion-1.8.10/sqlite-amalgamation
cd subversion-1.8.10
./configure --prefix=/usr/local/subversion-1.8.10
make && make install
cd ..
rm -rf subversion-1.8.10

echo "Install subversion 1.8.10 successfully."