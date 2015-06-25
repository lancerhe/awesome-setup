#!/bin/sh
#
# description: install node
#
# author: Lancer He <lancer.he@gmail.com>

if [ ! $1 ]; then
	echo 'Please type in tools folder.'
	exit
fi
if [ ! -f $1 ]; then
	mkdir -p $1
fi
tar zxf source.tar.gz -C $1

echo "Install successfully. Path: 
	$1\n"
echo "Change your nginx conf:
	server {
        	listen       8070;
        	index        index.html index.htm index.php;
        	root         $1;
        	autoindex    on;

        	location ~ .*\.(php|php5)?$ {
                	fastcgi_pass   127.0.0.1:9000;
                	fastcgi_index  index.php;
                	fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
               		include fastcgi_params;
        	}

        	location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|js|woff)$ {
                	expires 2h;
        	}
	}
"
