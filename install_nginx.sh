#!/bin/bash

echo "Updating packages..."
sudo yum update -y

echo "Installing Nginx..."
sudo yum install -y nginx

echo "Starting and enabling Nginx..."
sudo systemctl start nginx
sudo systemctl enable nginx

echo "Deploying web page..."
echo "<h1>Welcome to Nginx on Amazon Linux</h1>" | sudo tee /usr/share/nginx/html/index.html
