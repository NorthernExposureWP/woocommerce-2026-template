#!/bin/bash

set -Eeuo pipefail

PROJECT_DIR=/var/www/html
WORDPRESS_DIR="$PROJECT_DIR/public"

fail() {
    printf 'Initialization error: %s\n' "$1" >&2
    exit 1
}

require_env() {
    local name="$1"
    [[ -n "${!name:-}" ]] || fail "Required environment variable $name is missing. Copy .env.example to .env and configure it."
}

for variable in MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD WORDPRESS_ADMIN_USER \
    WORDPRESS_ADMIN_PASSWORD WORDPRESS_ADMIN_EMAIL WORDPRESS_SITE_URL WORDPRESS_SITE_TITLE; do
    require_env "$variable"
done

[[ -f "$WORDPRESS_DIR/wp-load.php" ]] || fail "WordPress Core is missing from $WORDPRESS_DIR."

cd "$PROJECT_DIR"

if [[ ! -f "$PROJECT_DIR/vendor/autoload.php" ]]; then
    printf 'Composer autoloader is missing; running composer install.\n'
    composer install --working-dir="$PROJECT_DIR" --no-interaction --prefer-dist \
        || fail "composer install failed. Check the Composer output and network access, then restart the PHP service."
fi

if [[ ! -f "$WORDPRESS_DIR/wp-config.php" ]]; then
    printf 'WordPress configuration is missing; creating it from the tracked example.\n'
    php "$PROJECT_DIR/bin/create-wp-config.php" \
        || fail "Could not create $WORDPRESS_DIR/wp-config.php. Check the config template and file permissions."
fi

printf 'Waiting for MySQL to become ready.\n'
mysql_ready=false
for attempt in {1..60}; do
    if mysqladmin ping --host=mysql --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --silent >/dev/null 2>&1; then
        mysql_ready=true
        break
    fi
    sleep 2
done
[[ "$mysql_ready" == true ]] || fail "MySQL did not become ready within 120 seconds. Check the mysql service logs and database settings."

wp_as_www_data() {
    su -p -s /bin/sh www-data -c 'cd /var/www/html && exec wp "$@"' sh "$@"
}

if wp_as_www_data core is-installed; then
    printf 'WordPress is already installed; preserving the existing site and administrator.\n'
else
    printf 'Installing WordPress.\n'
    wp_as_www_data core install \
        "--url=$WORDPRESS_SITE_URL" \
        "--title=$WORDPRESS_SITE_TITLE" \
        "--admin_user=$WORDPRESS_ADMIN_USER" \
        "--admin_password=$WORDPRESS_ADMIN_PASSWORD" \
        "--admin_email=$WORDPRESS_ADMIN_EMAIL" \
        --skip-email \
        || fail "WordPress installation failed. Check the PHP and MySQL logs before retrying. The database was not reset."
fi

if ! wp_as_www_data plugin is-active woocommerce >/dev/null 2>&1; then
    printf 'Activating WooCommerce.\n'
    wp_as_www_data plugin activate woocommerce \
        || fail "WooCommerce activation failed. Check that its plugin files are available and inspect the PHP logs."
fi

mkdir -p "$PROJECT_DIR/wp-content/uploads"
chown -R www-data:www-data "$PROJECT_DIR/wp-content/uploads"

exec "$@"
