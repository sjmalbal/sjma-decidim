#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/tmp/azure}"
DB_NAME="${LOCAL_DATABASE_NAME:-sjma_decidim_development}"
DB_PORT="${LOCAL_DATABASE_PORT:-5434}"
STAMP="$(date +%Y%m%d%H%M%S)"

mkdir -p "$OUT_DIR"

DUMP_PATH="$OUT_DIR/${DB_NAME}-${STAMP}.dump"
STORAGE_PATH="$OUT_DIR/active-storage-${STAMP}.tar.gz"

pg_dump \
  --port "$DB_PORT" \
  --format custom \
  --no-owner \
  --no-acl \
  --file "$DUMP_PATH" \
  "$DB_NAME"

tar -C "$ROOT_DIR" -czf "$STORAGE_PATH" storage

printf 'Database dump: %s\n' "$DUMP_PATH"
printf 'ActiveStorage archive: %s\n' "$STORAGE_PATH"
