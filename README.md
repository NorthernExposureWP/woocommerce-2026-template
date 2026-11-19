# WooCommerce 2026 Template

Minimal WooCommerce starter template for quickly creating new development stores.

The template contains the Docker environment, WordPress, WooCommerce, Composer setup, and a reproducible provisioning command.

Store-specific data such as products, categories, orders, customers, and other test data is intentionally not included.

## Requirements

* Docker Engine
* Docker Compose
* Git

## Setup

### 1. Create environment file

```bash
cp .env.example .env
```

### 2. Start Docker

```bash
docker compose up -d --build
```

On startup, the PHP container waits for MySQL, runs `composer install` if
`vendor/autoload.php` is missing, creates `public/wp-config.php` if it is
missing, installs WordPress if the database is not already installed, and
activates WooCommerce. The generated config contains unique salts and is ignored
by Git.

The administrator password in `.env.example` is for **localhost development
only**. Do not use it on a publicly accessible site or in production. Set a
different password in `.env` if the site will be reachable by anyone else.

Open the site at:

```text
http://localhost:8080
```

Set `WORDPRESS_PORT` in `.env` to change the host port. Apache continues to
listen on port 8080 inside the PHP container.

### 3. Provision the template when desired

Run:

```bash
./wpcli template provision
```

The provisioning command configures the reusable store baseline. It is not run
automatically:

* pretty permalinks;
* WooCommerce Coming Soon disabled;
* Home page;
* Shop page;
* Cart page;
* Checkout page;
* My Account page;
* WooCommerce page settings;
* Home as the site front page;
* primary navigation;
* removal of the default Sample Page.

The command is safe to run repeatedly.

On subsequent container starts, an existing `wp-config.php` is left untouched,
WordPress is not installed again, and the administrator account is not reset
from `.env`. WooCommerce is activated if it is not already active.

Changing the site URL after installation requires updating the saved WordPress
`home` and `siteurl` options. Changing the MySQL credentials after the database
volume has been initialized does not migrate that database or update its grants.
Do not remove the MySQL volume to recover from an initialization error; inspect
the PHP and MySQL logs and correct the reported configuration or connectivity
issue first.

After provisioning, the template provides the basic storefront flow:

```text
/                       Home
/shop/                  Product catalog
/product/...            Product page
/product-category/...   Product category
/cart/                  Cart
/checkout/              Checkout
/my-account/            My Account
/order-received/...     Order confirmation
```

The template does not create products, categories, customers, orders, or other store-specific data.

## WP-CLI

Use the project wrapper:

```bash
./wpcli core version
./wpcli plugin list
./wpcli theme list
./wpcli template provision
```

The wrapper uses the project's `wp-cli.yml` configuration.

## Composer autoload

Custom code uses the project-level Composer autoloader.

After adding or changing a custom namespace in `composer.json`:

```bash
docker compose exec -e XDEBUG_MODE=off php composer dump-autoload
```

Custom plugins must not contain their own `composer.json` or `vendor/` directory.

## Template architecture

The repository contains infrastructure and reusable configuration only.

Committed:

* Docker configuration;
* WordPress installation;
* WooCommerce;
* Composer configuration;
* WP-CLI configuration;
* provisioning code;
* the default theme.

Provisioned:

* WordPress/WooCommerce pages;
* WooCommerce page settings;
* permalink configuration;
* navigation;
* other reusable store settings.

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
