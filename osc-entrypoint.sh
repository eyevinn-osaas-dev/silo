#!/bin/bash
set -e

# OSC provides $PORT. nginx listens there and routes the S3 API to :9000 and the console (/ui/) to :9001.
export PORT="${PORT:-8080}"
sed "s/PORT_PLACEHOLDER/$PORT/g" /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Public URLs so presigned URLs and console redirects use the OSC hostname.
if [ -n "${OSC_HOSTNAME}" ]; then
  export MINIO_BROWSER_REDIRECT_URL="https://${OSC_HOSTNAME}/ui/"
  export MINIO_SERVER_URL="https://${OSC_HOSTNAME}"
else
  export MINIO_BROWSER_REDIRECT_URL="http://localhost:${PORT}/ui/"
  export MINIO_SERVER_URL="http://localhost:${PORT}"
fi

mkdir -p /data /run/nginx
nginx

exec "$@"
