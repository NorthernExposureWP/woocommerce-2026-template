<?php

declare(strict_types=1);

$template = __DIR__ . '/../public/wp-config.php.example';
$target = __DIR__ . '/../public/wp-config.php';

if (is_file($target)) {
    fwrite(STDOUT, "WordPress config already exists; leaving it unchanged.\n");
    exit(0);
}

$contents = file_get_contents($template);
if ($contents === false) {
    fwrite(STDERR, "Could not read public/wp-config.php.example.\n");
    exit(1);
}

$saltKeys = [
    'AUTH_KEY',
    'SECURE_AUTH_KEY',
    'LOGGED_IN_KEY',
    'NONCE_KEY',
    'AUTH_SALT',
    'SECURE_AUTH_SALT',
    'LOGGED_IN_SALT',
    'NONCE_SALT',
];

foreach ($saltKeys as $saltKey) {
    $placeholder = "__{$saltKey}__";
    if (substr_count($contents, $placeholder) !== 1) {
        fwrite(STDERR, "Expected exactly one {$placeholder} placeholder in the config template.\n");
        exit(1);
    }

    $contents = str_replace($placeholder, bin2hex(random_bytes(64)), $contents);
}

$handle = @fopen($target, 'x');
if ($handle === false) {
    if (is_file($target)) {
        fwrite(STDOUT, "WordPress config was created concurrently; leaving it unchanged.\n");
        exit(0);
    }

    fwrite(STDERR, "Could not create public/wp-config.php. Check file permissions.\n");
    exit(1);
}

$written = fwrite($handle, $contents);
fclose($handle);

if ($written !== strlen($contents)) {
    @unlink($target);
    fwrite(STDERR, "Could not write the complete public/wp-config.php file.\n");
    exit(1);
}

fwrite(STDOUT, "Created public/wp-config.php with unique persisted salts.\n");
