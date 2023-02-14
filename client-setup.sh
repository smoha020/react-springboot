#!/bin/bash

#FOR NGINX INSTALLATION ON AMAZON LINUX 2, MAKE SURE YOU FOLLOW THE STEPS IN THE NGINX WEBSITE BELOW
#https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-prebuilt-amazon-linux-2-packages


#FOR UBUNTU
#apt update -y && apt install nginx -y

#ASSUMING YOU HAVE ALREADY BUILT THE CLIENT PACKAGES, MOVE
#THE BUILD FOLDER TO THE RIGHT DIRECTORY

cp -R react-springboot/client/build/* /usr/share/nginx/html

#REPLACING THE SITES AVAILABLE/ENABLED FOLDERS AND
#CREATING SYMLINKS IS EASIER WITH DEBIAN/UBUNTU 
#BECAUSE THE 'sites-enabled/available' FOLDERS EXIST
#IN THOSE DISTRIBUTIONS BUT NOT IN CENTOS/AMAZON LINUX, 
#SO WE WILL SET UP NGINX USING THE CONF FILE INSTEAD. 
#USING THE CONF FILE WORKS FOR ALL DISTRIBUTIONS

#rm -rf /etc/nginx/sites-enabled/default
#rm -rf /etc/nginx/sites-available/default

rm /etc/nginx/conf.d/default.conf

#CREATE CONF FILE

cat <<EOT> /etc/nginx/conf.d/client.conf
server {

    listen               80;

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

#CREATE SYMLINK (AS MENTIONED ABOVE) 
#ln -s /etc/nginx/sites-available/client /etc/nginx/sites-enabled/client

systemctl start nginx.service
systemctl enable nginx.service
