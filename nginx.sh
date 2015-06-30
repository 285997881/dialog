#!/bin/bash
#
echo "需先安装"Development tools" "Server Platform Development" pcre-devel"

yum groupinstall -y "Development tools" > /dev/null
yum groupinstall -y "Server Platform Development" > /dev/null
yum install -y pcre-devel > /dev/null

echo "依赖关系安装完成"

ntp同步
ntpdate ntp.org 


添加nginx用户
groupadd -r nginx
useradd -r -g nginx nginx (-r 系统用户)

wget http://nginx.org/download/nginx-1.6.3.tar.gz
tar xvf nginx-1.6.3.tar.gz
cd nginx-1.6.3.tar.gz 

./configure \
  --prefix=/usr \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx/nginx.pid  \
  --lock-path=/var/lock/nginx.lock \
  --user=nginx \
  --group=nginx \
  --with-http_ssl_module \
  --with-http_flv_module \
  --with-http_stub_status_module \
  --with-http_gzip_static_module \
  --http-client-body-temp-path=/var/tmp/nginx/client/ \
  --http-proxy-temp-path=/var/tmp/nginx/proxy/ \
  --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ \
  --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
  --http-scgi-temp-path=/var/tmp/nginx/scgi \
  --with-pcre



