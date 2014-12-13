#!/bin/sh
#
# description: install node
#
# author: Lancer He <lancer.he@gmail.com>
yum install -y gcc-c++ openssl-devel
cd /usr/local/src/
if [ ! -e node-v0.10.4.tar.gz ]; then
    wget http://nodejs.org/dist/v0.10.4/node-v0.10.4.tar.gz
fi

tar zxf node-v0.10.4.tar.gz
cd node-v0.10.4
./configure --prefix=/usr/local/node-0.10.4
make -j 4
make install
cd ..
rm -rf node-v0.10.4

echo "Install node 0.10.4 successfully."