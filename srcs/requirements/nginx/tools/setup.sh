#!/bin/bash

# Exit immediately if a command fails
set -e

# Ensure DOMAIN_NAME is set
if [ -z "$DOMAIN_NAME" ]; then
    echo "Error: DOMAIN_NAME environment variable not set!"
    exit 1
fi

# Create SSL directory if it doesn't exist
mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
openssl req -x509 -nodes -days 365 \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=student/CN=${DOMAIN_NAME}" \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

echo "✅ SSL certificate generated for ${DOMAIN_NAME}"

# Start NGINX in the foreground
echo "Starting NGINX..."
nginx -g "daemon off;"
