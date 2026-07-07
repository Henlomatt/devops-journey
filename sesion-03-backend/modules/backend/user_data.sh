#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>Desplegado con Terraform y User Data</h1>" > /var/www/html/index.html