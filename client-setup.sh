#!/bin/bash

#FOR NGINX INSTALLATION ON AMAZON LINUX 2, MAKE SURE YOU FOLLOW THE STEPS IN THE NGINX WEBSITE BELOW
#https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-prebuilt-amazon-linux-2-packages

#--------IMPORTANT NOTES ON NGINX--------------
#REPLACING THE SITES AVAILABLE/ENABLED FOLDERS AND
#CREATING SYMLINKS IS EASIER WITH DEBIAN/UBUNTU 
#BECAUSE THE 'sites-enabled/available' FOLDERS EXIST
#IN THOSE DISTRIBUTIONS BUT NOT IN CENTOS/AMAZON LINUX.
#THE REASON IS THAT INSIDE THE DEFUALT NGINX CONF FILE
#(WHICH ON BOTH DISTRIBUTIONS IS LOCATED IN '/etc/nginx/nginx.conf')
#I RECOMMEND YOU DON'T DELETE THE DEFAULT CONF SINCE IT CONTAINS 
#IMPORTANT STUFF THE 'http' AND 'events' DIRECTIVES.
#INSIDE THE DEFAULT CONF, THERE IS A LINE THAT SAYS '
#include /etc/nginx/conf.d/*.conf;' FOR BOTH DISTRIBUTIONS BUT 
#THERE IS AN ADDITIONAL LINE IN UBUNTU THAT SAYS
#'include /etc/nginx/sites-enabled/*;' SO THIS IS WHY THE 
#'/etc/nginx/sites-enabled and sites-enabled/' DON'T
#EXIST ON AMAZON LINUX 2 DISTRIBUTION.


#----------IMPORTANT NOTE ON FRONT-END AXIOS ROUTES--------
#MAKE SURE THEY DON'T START WITH 'localhost'. 



#ASSUMING YOU HAVE ALREADY BUILT THE CLIENT PACKAGES, MOVE
#THE BUILD FOLDER TO THE RIGHT DIRECTORY

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

