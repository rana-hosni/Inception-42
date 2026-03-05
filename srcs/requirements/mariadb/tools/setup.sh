#!/bin/bash
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Start MariaDB in background
mysqld_safe --datadir=/var/lib/mysql &

# Wait for socket file
echo "Waiting for MariaDB socket..."
while [ ! -S /run/mysqld/mysqld.sock ]; do
    sleep 1
done

# Give it a moment to fully initialize
sleep 2

# Wait until MariaDB is ready to accept connections
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping --silent; do
    echo "MariaDB not ready yet, retrying..."
    sleep 2
done

echo "MariaDB is ready!"

# Choose root authentication mode
if mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1;" >/dev/null 2>&1; then
    ROOT_AUTH_CMD="mysql -u root -p\"${MYSQL_ROOT_PASSWORD}\""
    NEED_SET_ROOT_PASSWORD=0
elif mysql -u root -e "SELECT 1;" >/dev/null 2>&1; then
    ROOT_AUTH_CMD="mysql -u root"
    NEED_SET_ROOT_PASSWORD=1
else
    echo "Unable to authenticate as root. Check MYSQL_ROOT_PASSWORD and persisted MariaDB data."
    exit 1
fi

# Build SQL setup script
SQL_SETUP=$(cat <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
EOF
)

if [ "$NEED_SET_ROOT_PASSWORD" -eq 1 ]; then
    SQL_SETUP="${SQL_SETUP}
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
fi

SQL_SETUP="${SQL_SETUP}
FLUSH PRIVILEGES;"

# Run setup with error handling
echo -e "$SQL_SETUP" | eval "$ROOT_AUTH_CMD" || { echo "MySQL setup failed"; exit 1; }

# Stop background MariaDB
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown || {
    echo "Failed to shutdown MariaDB gracefully"
    exit 1
}

# Start MariaDB in foreground
exec mysqld_safe --datadir=/var/lib/mysql