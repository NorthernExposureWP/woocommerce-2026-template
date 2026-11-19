# Testing

## Structure

Unit and integration tests are organized at the project level:

tests/
├── bootstrap.php
├── Unit/
└── Integration/

Add unit tests under `tests/Unit/` and integration tests under
`tests/Integration/`. PHPUnit registers both directories in the root
`phpunit.xml`.

## Running Tests

Run all tests:

docker compose exec -T \
-e XDEBUG_MODE=off \
-w /var/www/html \
php vendor/bin/phpunit

Run only Unit tests:

docker compose exec -T \
-e XDEBUG_MODE=off \
-w /var/www/html \
php vendor/bin/phpunit --testsuite Unit

Run only Integration tests:

docker compose exec -T \
-e XDEBUG_MODE=off \
-w /var/www/html \
php vendor/bin/phpunit --testsuite Integration

PHPUnit uses `tests/bootstrap.php`, which loads both the project Composer
autoloader and WordPress via `wp-load.php`.
