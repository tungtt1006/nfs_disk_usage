#!/bin/bash

# Exit on fail
set -e

# Start cronjob
crond

# Start nginx
nginx -g "daemon off;"

# Finally call command issued to the docker service
exec "$@"
