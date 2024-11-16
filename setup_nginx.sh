#!/bin/bash

# Update package lists
apt update -y

# Install Nginx
apt install nginx -y

# Create directories for the websites
mkdir -p /var/www/sub1.rprass.my.id
mkdir -p /var/www/sub2.rprass.my.id

# Set ownership
chown -R www-data:www-data /var/www/

# Create a simple HTML file for sub1
echo "<h1>Congratulations! The sub1.rprass.my.id website is working! Run at port 81</h1>" | tee /var/www/sub1.rprass.my.id/index.html

# Create a simple HTML file for sub2
echo "<h1>Congratulations! The sub2.rprass.my.id website is working! Run at port 80</h1>" | tee /var/www/sub2.rprass.my.id/index.html

# Create the Nginx server block file for sub1
cat <<EOF | tee /etc/nginx/sites-available/sub1.rprass.my.id > /dev/null
server {
    listen 81;
    server_name sub1.rprass.my.id;

    root /var/www/sub1.rprass.my.id;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Create the Nginx server block file for sub2
cat <<EOF | tee /etc/nginx/sites-available/sub2.rprass.my.id > /dev/null
server {
    listen 80;
    server_name sub2.rprass.my.id;

    root /var/www/sub2.rprass.my.id;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Enable the sites
ln -s /etc/nginx/sites-available/sub1.rprass.my.id /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/sub2.rprass.my.id /etc/nginx/sites-enabled/

# Test Nginx configuration
nginx -t

# Restart Nginx to apply changes
systemctl restart nginx

echo "Nginx setup for sub1.rprass.my.id and sub2.rprass.my.id completed!"
