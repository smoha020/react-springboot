#!/bin/bash

#ASSUMING YOU HAVE ALREADY BUILT THE CLIENT PACKAGES

yum update -y && yum install nginx -y

#MOVE THE BUILD FOLDER TO THE RIGHT DIRECTORY

cp -R react-springboot/client/build/* /usr/share/nginx/html

#DELETE OLD FOLDERS AND REPLACE WITH NEW ONES

rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default


#CREATE CONF FILE

cat <<EOT> /etc/nginx/sites-available/client
server {
    
    listen               80;
    
    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        try_files $uri $uri/ =404;
    }
    
    location /api {
        proxy_pass       http://localhost:8080
        
        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
   }
}  
EOT

#CREATE SYMLINK

ln -s /etc/nginx/sites-available/client /etc/nginx/sites-enabled/client

systemctl enable nginx.service




