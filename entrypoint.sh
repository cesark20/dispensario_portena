#!/bin/sh

set -e

# Elimina el server.pid si quedó colgado
rm -f /app/tmp/pids/server.pid

exec "$@"