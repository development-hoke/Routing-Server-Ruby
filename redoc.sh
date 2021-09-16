#!/bin/sh
# ------------------------------
# ローカルで openapi.yml からAPI仕様書を生成するスクリプト
# ------------------------------
PUBLIC_DIR="/app/public"
docker-compose exec app sh -c "[ ! -e ${PUBLIC_DIR} ] && mkdir ${PUBLIC_DIR}"
docker-compose exec app sh -c "redoc-cli bundle /docs/openapi.yml && mv redoc-static.html public/redoc.html"

if [ $? = 0 ]; then
  echo "\n[API仕様書] http://localhost:3080/redoc.html"
fi
