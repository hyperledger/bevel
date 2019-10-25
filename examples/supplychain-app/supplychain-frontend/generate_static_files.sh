#!/bin/bash
npm run build
cp -r build/. /var/www
ls /var/www
cp nginx.conf /etc/nginx/nginx.conf

echo "daemon off;" >> /etc/nginx/nginx.conf
