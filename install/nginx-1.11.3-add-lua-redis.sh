#!/bin/sh
#
# description: install nginx
#
# author: Lancer He <lancer.he@gmail.com>


cd /usr/local/src

yum install -y pcre-devel openssl-devel gcc curl


# LuaJIT
wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz
tar zxvf LuaJIT-2.0.5.tar.gz
cd LuaJIT-2.0.5
make && make install PREFIX=/usr/local/LuaJIT-2.0.5
echo "/usr/local/LuaJIT-2.0.5/lib" > /etc/ld.so.conf.d/luajit.conf
cd /usr/local/src
rm -rf LuaJIT-2.0.5

export LUAJIT_LIB=/usr/local/LuaJIT-2.0.5/lib/
export LUAJIT_INC=/usr/local/LuaJIT-2.0.5/include/luajit-2.0/
ln -s /usr/local/LuaJIT-2.0.5/lib/libluajit-5.1.so.2 /lib64/libluajit-5.1.so.2


# ngx_devel_kit0
wget -O ngx_devel_kit-0.3.1.tar.gz https://github.com/simplresty/ngx_devel_kit/archive/v0.3.1rc1.tar.gz
tar zxvf ngx_devel_kit-0.3.1.tar.gz


# lua-nginx-module
wget -O lua-nginx-module-0.10.13.tar.gz https://github.com/openresty/lua-nginx-module/archive/v0.10.13.tar.gz
tar zxvf lua-nginx-module-0.10.13.tar.gz


# lua-nginx-redis
wget -O lua-resty-redis-0.26.tar.gz https://github.com/openresty/lua-resty-redis/archive/v0.26.tar.gz
tar zxvf lua-resty-redis-0.26.tar.gz
mv lua-resty-redis-0.26 /usr/local/


# rebuild
tar zxvf nginx-1.11.3.tar.gz
cd nginx-1.11.3
./configure --prefix=/usr/local/nginx-1.11.3 --with-stream --with-stream_ssl_module --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --add-module=/usr/local/src/ngx_devel_kit-0.3.1rc1/ --add-module=/usr/local/src/lua-nginx-module-0.10.13/
make 
./objs/nginx -t
/etc/init.d/nginx stop
mv /usr/local/nginx-1.11.3/sbin/nginx /usr/local/nginx-1.11.3/sbin/nginx-backup
mv objs/nginx /usr/local/nginx-1.11.3/sbin/nginx
chmod +x /usr/local/nginx-1.11.3/sbin/nginx
/etc/init.d/nginx start
echo "If success, run 'rm -f /usr/local/nginx-1.11.3/sbin/nginx-backup'"
echo "Else run 'mv /usr/local/nginx-1.11.3/sbin/nginx-backup /usr/local/nginx-1.11.3/sbin/nginx'"
cd /usr/local/src
rm -rf nginx-1.11.3 ngx_devel_kit-0.3.1rc1 lua-nginx-module-0.10.13
