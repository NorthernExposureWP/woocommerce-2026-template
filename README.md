# WooCommerce 2026 Template

Minimal WooCommerce starter template for quickly creating new development stores.

The template contains the Docker environment, WordPress, WooCommerce, and Composer setup.

Store-specific data such as products, categories, orders, customers, and other test data is intentionally not included.

## Requirements

* Docker Engine
* Docker Compose
* Git

## Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Create environment file

```bash
cp .env.example .env
```

The example database settings are `MYSQL_DATABASE=woocommerce`,
`MYSQL_USER=woocommerce`, `MYSQL_PASSWORD=woocommerce`, and
`MYSQL_ROOT_PASSWORD=root`. `MYSQL_ROOT_PASSWORD` configures the MySQL server's
root account for MySQL administration; it is not used in the WordPress database
configuration wizard. WordPress uses `MYSQL_DATABASE`, `MYSQL_USER`, and
`MYSQL_PASSWORD`, with `mysql` as the database host. If you change the database
name, user, or password in `.env`, use the matching values in the wizard.

### 3. Start Docker

```bash
docker compose up -d --build
```

### 4. Install Composer dependencies

```bash
docker compose exec -e XDEBUG_MODE=off php composer install
```

### 5. Install WordPress

Open the site in your browser:

```text
http://localhost:8080
```

In the WordPress database configuration wizard, enter the database name, user,
and password from `.env`. Set the database host to `mysql` and leave the table
prefix as `wp_` unless you need a different prefix.

After validating the database connection, WordPress creates
`public/wp-config.php`. If it cannot write the file, it displays the generated
configuration for you to save manually as `public/wp-config.php`.

Before clicking **Run the installation**, add the project Composer autoloader
and the project content directory settings to `public/wp-config.php`:

```php
require_once dirname(__DIR__) . '/vendor/autoload.php';

define('WP_CONTENT_DIR', dirname(__DIR__) . '/wp-content');
define('WP_CONTENT_URL', 'http://localhost:8080/wp-content');
```

Then complete the WordPress installation in the browser. The project-level
`wp-content/` directory is exposed by Docker/Apache at `/wp-content/`.

### 6. Activate WooCommerce

After completing the WordPress installation, activate WooCommerce as the final setup step.

WooCommerce 11.1.2 is included in the repository:

```text
wp-content/plugins/woocommerce/
```

Activate it with WP-CLI:

```bash
./wpcli plugin activate woocommerce
```

The template does not create products, categories, customers, orders, or other store-specific data.

## WP-CLI

Use the project wrapper:

```bash
./wpcli core version
./wpcli plugin list
./wpcli theme list
```

The wrapper uses the project's `wp-cli.yml` configuration.

## Composer autoload

Custom code uses the project-level Composer autoloader configured in
`public/wp-config.php`. See
[Project-level Composer Autoloading](docs/ARCHITECTURE.md) for details.

After adding or changing a custom namespace in `composer.json`:

```bash
docker compose exec -e XDEBUG_MODE=off php composer dump-autoload
```

Custom plugins must not contain their own `composer.json` or `vendor/` directory.

## Template architecture

The repository contains infrastructure for a WordPress/WooCommerce development environment.

Committed:

* Docker configuration;
* WordPress installation;
* WooCommerce;
* Composer configuration;
* WP-CLI configuration;
* the default theme.

Not included:

* products;
* product categories and attributes;
* customers;
* orders;
* store-specific content;
* educational/test plugins.

## Possible issues

### Image uploads

If image uploads from the WordPress admin do not work correctly, uncomment the corresponding volume mapping in `compose.yaml` and rebuild:

```bash
docker compose up -d --build
```
