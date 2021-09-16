#!/bin/bash
# ------------------------------
# ローカルサーバーを起動するスクリプト
# ------------------------------
DB_PATH="./docker/db/mysql_data/onedate_db"
DB_CORE_PATH="${DB_PATH}/schema_migrations.frm"
RUN_COMMAND="docker-compose exec app sh -c \"bundle exec rails s -b 0.0.0.0\""

echo "===================================="
echo " Starting 1Date Server ...."
echo " Listening on http://localhost:3080 "
echo "===================================="

# docker-compose up 直後の場合DBが作られるのを待つ
if [ -e ${DB_CORE_PATH} ]; then
  eval ${RUN_COMMAND}
  exit 0
else
  /bin/echo -n "Creating database ... "
fi
while [ ! -d ${DB_PATH} ]; do
  sleep 1
done
echo "done."

# スキーマ反映とサンプルデータ投入がまだなら行う
if [ ! -e ${DB_CORE_PATH} ]; then
  /bin/echo -n "Setup database ... "
  docker-compose exec app sh -c "bundle exec rails db:reset" > /dev/null
  echo "done."
else
  :
fi

eval ${RUN_COMMAND}
