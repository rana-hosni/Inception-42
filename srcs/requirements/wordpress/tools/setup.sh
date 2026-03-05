#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

sleep 10

echo -e "${BLUE}=== WordPress Setup Script ===${NC}"

escape_sed_replacement() {
    printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g'
}

# Download and configure WordPress if not already present
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo -e "${YELLOW}Downloading WordPress...${NC}"
    
    # Download WordPress
    wget -q https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz --strip-components=1
    rm latest.tar.gz
    
    # Create wp-config.php
    echo -e "${YELLOW}Configuring WordPress...${NC}"
    cp wp-config-sample.php wp-config.php
    
    # Replace database configuration safely
    SAFE_DB_NAME="$(escape_sed_replacement "${MYSQL_DATABASE}")"
    SAFE_DB_USER="$(escape_sed_replacement "${MYSQL_USER}")"
    SAFE_DB_PASSWORD="$(escape_sed_replacement "${MYSQL_PASSWORD}")"

    sed -i "s|database_name_here|${SAFE_DB_NAME}|g" wp-config.php
    sed -i "s|username_here|${SAFE_DB_USER}|g" wp-config.php
    sed -i "s|password_here|${SAFE_DB_PASSWORD}|g" wp-config.php
    sed -i "s|localhost|mariadb|g" wp-config.php

    # Generate and inject WordPress salts
    echo -e "${YELLOW}Generating salts...${NC}"
    SALTS_FILE="$(mktemp)"
    if curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/ -o "${SALTS_FILE}"; then
        awk -v salts_file="${SALTS_FILE}" '
            BEGIN { inserted = 0; skipping = 0 }
            {
                if ($0 ~ /AUTH_KEY/ && inserted == 0) {
                    while ((getline line < salts_file) > 0) print line
                    inserted = 1
                    skipping = 1
                    next
                }

                if (skipping == 1) {
                    if ($0 ~ /NONCE_SALT/) {
                        skipping = 0
                    }
                    next
                }

                print
            }
        ' wp-config.php > wp-config.php.tmp && mv wp-config.php.tmp wp-config.php
    else
        echo -e "${YELLOW}⚠ Could not fetch salts, keeping default sample salts${NC}"
    fi
    rm -f "${SALTS_FILE}"
    
    # Set proper permissions
    chown -R www-data:www-data /var/www/html
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;
    
    echo -e "${GREEN}✓ WordPress configured successfully${NC}"
else
    echo -e "${GREEN}✓ WordPress already configured${NC}"
fi

# Wait for MariaDB to be ready - using /dev/tcp instead of mysqladmin
echo -e "${YELLOW}Waiting for MariaDB...${NC}"
DB_HOST="mariadb"
DB_PORT="3306"
TIMEOUT=60

for i in $(seq 1 $TIMEOUT); do
    if timeout 1 bash -c "echo > /dev/tcp/${DB_HOST}/${DB_PORT}" 2>/dev/null; then
        echo -e "${GREEN}✓ MariaDB port is open${NC}"
        break
    fi
    echo -n "."
    sleep 1
    if [ $i -eq $TIMEOUT ]; then
        echo -e "${RED}✗ MariaDB port not open after ${TIMEOUT} seconds${NC}"
        exit 1
    fi
done

# Give MariaDB a moment to fully initialize
sleep 5

# Test database connection using PHP
echo -e "${YELLOW}Testing database connection...${NC}"
php -r "
\$connected = false;
for(\$i=0; \$i<10; \$i++) {
    try {
        \$mysqli = new mysqli('mariadb', '${MYSQL_USER}', '${MYSQL_PASSWORD}', '${MYSQL_DATABASE}');
        if (!\$mysqli->connect_error) {
            \$connected = true;
            echo \"✓ Successfully connected to database\n\";
            break;
        } else {
            echo \"Connection attempt \$i failed: \" . \$mysqli->connect_error . \"\n\";
        }
    } catch (Exception \$e) {
        echo \"Exception: \" . \$e->getMessage() . \"\n\";
    }
    sleep(2);
}
exit(\$connected ? 0 : 1);
"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database connection successful${NC}"
else
    echo -e "${RED}✗ Database connection failed${NC}"
    echo -e "${YELLOW}Will continue anyway, WordPress might handle it...${NC}"
fi

# Start PHP-FPM
echo -e "${GREEN}Starting PHP-FPM...${NC}"
exec /usr/sbin/php-fpm8.2 -F