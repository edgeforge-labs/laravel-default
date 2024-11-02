For the listed PHP extensions, here are the typical dependencies needed on Alpine Linux:

1. **intl** - Requires `icu-dev`
2. **ctype** - No additional dependencies needed (part of PHP core)
3. **curl** - Requires `curl-dev`
4. **dom** - Requires `libxml2-dev`
5. **fileinfo** - No additional dependencies needed (part of PHP core)
6. **filter** - No additional dependencies needed (part of PHP core)
7. **hash** - No additional dependencies needed (part of PHP core)
8. **mbstring** - Requires `oniguruma-dev` for regex support
9. **pdo** - No additional dependencies needed for core PDO, but each PDO driver (e.g., `pdo_mysql`, `pdo_pgsql`) requires its own library
10. **session** - No additional dependencies needed (part of PHP core)
11. **tokenizer** - No additional dependencies needed (part of PHP core)
12. **xml** - Requires `libxml2-dev`
13. **pcre** - Typically, the `pcre` library is already included with PHP and doesn’t require additional packages in Alpine
14. **openssl** - Requires `openssl-dev`


### Checking Enabled PHP Extensions

To see which extensions are enabled in PHP’s CLI mode, you can run:

```bash
php --ini
```

This command lists the configuration files loaded by PHP. Any additional configuration files, besides `docker-fpm.ini`, will be named with the extension they enable, making it easy to identify active extensions.