#!/bin/sh
#
# description: install git
#
# author: Lancer He <lancer.he@gmail.com>
yum install -y gcc unzip gettext-devel expat-devel curl-devel zlib-devel openssl-devel perl-devel
cd /usr/local/src/
if [ ! -e git-2.2.0-rc3.zip ]; then
    wget https://github.com/git/git/archive/v2.2.0-rc3.zip -O git-2.2.0-rc3.zip
fi

unzip git-2.2.0-rc3.zip
cd git-2.2.0-rc3
autoconf 
./configure --prefix=/usr/local/git-2.2.0
make -j 4
make install
cd ..
rm -rf git-2.2.0-rc3

echo "Install git 2.2.0 successfully."