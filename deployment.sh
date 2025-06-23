#!/bin/bash

php artisan down
echo "Set laravel in maintenance mode"

git fetch
git checkout $branch
git pull
git rev-parse HEAD > .version

composer install --no-dev
echo "Composer has been updated"

php artisan package:discover
echo "Packages discovered"

# If you have a backup command
#echo "Backing up database..."
#php artisan db:backup

echo "Starting to migrate master database"
php artisan migrate --force
echo "Migration of master-database was successful"

php artisan config:clear
php artisan permission:cache-reset
php artisan cache:clear
php artisan view:clear
echo "Cache cleared..."

npm ci
npm run production

echo "Set laravel in production mode"
php artisan up