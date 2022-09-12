#!/bin/sh

echo "Runnning Database Migrations..."
yes | python manage.py migrate

echo "Runnning Create Cache Table..."
yes | python manage.py createcachetable

echo "Runnning CollectStatic..."
yes | python manage.py collectstatic --no-input

echo "starting $@"
exec "$@"
