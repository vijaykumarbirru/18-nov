#!/bin/bash
apt update -y
apt install -y nginx

echo "<h1>Gateway EC2 is running</h1>" > /var/www/html/index.html

systemctl restart nginx
