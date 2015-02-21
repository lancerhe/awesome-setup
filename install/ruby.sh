#!/bin/sh
#
# description: install git
#
# author: Lancer He <lancer.he@gmail.com>
yum install -y gcc openssl-devel zlib-devel gcc gcc-c++ make autoconf readline-devel curl-devel expat-devel gettext-devel ncurses-devel libyaml-devel libyaml
cd /usr/local/src/
if [ ! -e yaml-0.1.4.tar.gz ]; then
    wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
fi

if [ ! -e ruby-1.9.3-p0.tar.gz ]; then
    wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p0.tar.gz
fi

tar zxf yaml-0.1.4.tar.gz
cd yaml-0.1.4
./configure --prefix=/usr/local
make && make install
cd ..
rm -rf yaml-0.1.4

tar zxf ruby-1.9.3-p0.tar.gz
cd ruby-1.9.3-p0
sed -i '759 a#if !defined(OPENSSL_NO_EC2M)' ext/openssl/ossl_pkey_ec.c
sed -i '762 a#endif' ext/openssl/ossl_pkey_ec.c
sed -i '816 a#if !defined(OPENSSL_NO_EC2M)' ext/openssl/ossl_pkey_ec.c
sed -i '819 a#endif' ext/openssl/ossl_pkey_ec.c
./configure --prefix=/usr/local/ruby-1.9.3 --disable-install-doc --with-opt-dir=/usr/local/lib
make && make install
cd ..
rm -rf ruby-1.9.3-p0 

echo "Install ruby 1.9.3 successfully."
