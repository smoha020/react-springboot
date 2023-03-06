#!/bin/bash

apt update -y && apt install -y nginx 

cp -R react-springboot/client/build/* /usr/share/nginx/html


rm -rf /etc/nginx/conf.d/*.conf

#CREATE CONF FILE

cat <<EOT> /etc/nginx/conf.d/client.conf
server {

    listen               80;
    server_name          localhost;
    
    
    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        try_files $uri $uri/ =404;
    }

    location /api {
        proxy_pass       http://localhost:8080;

        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
    }
}
EOT

systemctl enable nginx.service
systemctl start nginx.service

