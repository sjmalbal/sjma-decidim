#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <storage-account> <container> <storage-root>" >&2
  exit 64
fi

STORAGE_ACCOUNT="$1"
CONTAINER="$2"
STORAGE_ROOT="$3"

if [[ ! -d "$STORAGE_ROOT" ]]; then
  echo "Storage root not found: $STORAGE_ROOT" >&2
  exit 66
fi

AZURE_STORAGE_KEY="${AZURE_STORAGE_KEY:-$(az storage account keys list \
  --account-name "$STORAGE_ACCOUNT" \
  --query '[0].value' \
  --output tsv)}"

find "$STORAGE_ROOT" -type f -print0 | while IFS= read -r -d '' path; do
  key="$(basename "$path")"
  az storage blob upload \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$AZURE_STORAGE_KEY" \
    --container-name "$CONTAINER" \
    --name "$key" \
    --file "$path" \
    --overwrite true \
    --only-show-errors
done

printf 'Uploaded ActiveStorage files from %s to %s/%s\n' "$STORAGE_ROOT" "$STORAGE_ACCOUNT" "$CONTAINER"
