#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <dump-file>" >&2
  exit 64
fi

: "${AZURE_POSTGRES_SERVER:?Set AZURE_POSTGRES_SERVER}"
: "${AZURE_POSTGRES_ADMIN:=sjmaadmin}"
: "${AZURE_POSTGRES_PASSWORD:?Set AZURE_POSTGRES_PASSWORD}"
: "${AZURE_POSTGRES_DATABASE:=sjma_decidim_production}"
: "${APP_HOST:?Set APP_HOST, for example sjma-decidim.azurewebsites.net}"

DUMP_PATH="$1"
PG_RESTORE_BIN="${PG_RESTORE_BIN:-pg_restore}"
PSQL_BIN="${PSQL_BIN:-psql}"

if [[ "$PG_RESTORE_BIN" == "pg_restore" && -x /usr/lib/postgresql/16/bin/pg_restore ]]; then
  PG_RESTORE_BIN="/usr/lib/postgresql/16/bin/pg_restore"
fi

if [[ "$PSQL_BIN" == "psql" && -x /usr/lib/postgresql/16/bin/psql ]]; then
  PSQL_BIN="/usr/lib/postgresql/16/bin/psql"
fi

export PGPASSWORD="$AZURE_POSTGRES_PASSWORD"

"$PG_RESTORE_BIN" \
  --clean \
  --if-exists \
  --no-owner \
  --no-acl \
  --host "${AZURE_POSTGRES_SERVER}.postgres.database.azure.com" \
  --port 5432 \
  --username "$AZURE_POSTGRES_ADMIN" \
  --dbname "$AZURE_POSTGRES_DATABASE" \
  "$DUMP_PATH"

"$PSQL_BIN" \
  "sslmode=require host=${AZURE_POSTGRES_SERVER}.postgres.database.azure.com port=5432 dbname=${AZURE_POSTGRES_DATABASE} user=${AZURE_POSTGRES_ADMIN} password=${AZURE_POSTGRES_PASSWORD}" \
  -c "update decidim_organizations set host = '${APP_HOST}', secondary_hosts = array_remove(array_append(secondary_hosts, 'localhost'), '${APP_HOST}'); update active_storage_blobs set service_name = 'azure' where service_name = 'local';"

printf 'Restored database and configured host %s\n' "$APP_HOST"
