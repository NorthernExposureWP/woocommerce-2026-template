#!/bin/bash

set -e

chown -R www-data:www-data /var/www/html/wp-content/uploads

exec "$@"
