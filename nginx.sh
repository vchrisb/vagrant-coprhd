#!/bin/bash

#install nginx
cd /tmp
wget 'http://nginx.org/download/nginx-1.6.2.tar.gz'
wget 'https://github.com/yaoweibin/nginx_upstream_check_module/archive/v0.3.0.tar.gz'
wget 'https://github.com/openresty/headers-more-nginx-module/archive/v0.25.tar.gz'
tar -xzvf nginx-1.6.2.tar.gz
tar -xzvf v0.3.0.tar.gz
tar -xzvf v0.25.tar.gz
cd nginx-1.6.2
patch -p1 < ../nginx_upstream_check_module-0.3.0/check_1.5.12+.patch
./configure --add-module=../nginx_upstream_check_module-0.3.0 --add-module=../headers-more-nginx-module-0.25 --with-http_ssl_module --prefix=/usr --conf-path=/etc/nginx/nginx.conf
make
make install