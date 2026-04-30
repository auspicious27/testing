#!/bin/bash

# Start Apache service
systemctl start httpd

# Enable Apache to start on boot
systemctl enable httpd

# Set proper permissions for web files
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Check if Apache is running
if systemctl is-active --quiet httpd; then
    echo "Apache web server started successfully!"
else
    echo "Failed to start Apache web server"
    exit 1
fi