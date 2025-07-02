#!/bin/bash

# Install Nginx on CentOS Stream 9
dnf install -y epel-release
dnf install -y nginx

# Create Nginx config for vproapp
cat <<EOT > /etc/nginx/conf.d/vproapp.conf
upstream vproapp {
    server app01:8080;
}

server {
    listen 80;

    location / {
        proxy_pass http://vproapp;
    }
}
EOT

systemctl start firewalld 
systemctl enable firewalld
firewall-cmd --add-port=80/tcp
firewall-cmd --runtime-to-permanent
firewall-cmd --list-all
systemctl restart firewalld

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx
systemctl restart nginx
