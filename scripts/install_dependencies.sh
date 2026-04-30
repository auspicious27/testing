#!/bin/bash

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Create web directory if it doesn't exist
mkdir -p /var/www/html

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

echo "Dependencies installed successfully!"