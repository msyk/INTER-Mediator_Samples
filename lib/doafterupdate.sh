#!/bin/bash

DB_ENGINE="mysql" # mysql or postgresql
DB_NAME="test_db"

myDir=$(
  cd $(dirname "$0")
  pwd
)
appRootDir=$(dirname "${myDir}")

platform=`uname -a`
case "${platform}" in
  *Linux*) sudoReq="sudo" ;;
  *Darwin*) sudoReq="" ;;
esac

read -p "Do you want to update database, type 'YES'. -->" choice
if [ "${choice}" = "YES" ]; then
  case "${DB_ENGINE}" in
    *mysql*)
      schemaDir="${appRootDir}/lib/MySQL_Schema"
      cd "${schemaDir}"
      ${sudoReq} mysql -uroot ${DB_NAME} <schema_update.sql
      ${sudoReq} mysql -uroot ${DB_NAME} <schema_views.sql
      ;;
    *postgresql*)
      schemaDir="${appRootDir}/lib/PostgreSQL_Schema"
      cd "${schemaDir}"
      ${sudoReq} psql -f schema_update.sql -h localhost ${DB_NAME}
      ${sudoReq} psql -f schema_views.sql -h localhost ${DB_NAME}
      ;;
  esac
fi
