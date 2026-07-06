#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

: "${AZURE_RESOURCE_GROUP:=sjma-decidim-rg}"
: "${AZURE_LOCATION:=westeurope}"
: "${AZURE_APP_NAME:=sjma-decidim}"
: "${AZURE_PLAN_NAME:=${AZURE_APP_NAME}-plan}"
: "${AZURE_ACR_NAME:?Set AZURE_ACR_NAME to a globally unique lowercase ACR name}"
: "${AZURE_ACR_SKU:=Basic}"
: "${AZURE_POSTGRES_SERVER:?Set AZURE_POSTGRES_SERVER to a globally unique PostgreSQL server name}"
: "${AZURE_POSTGRES_ADMIN:=sjmaadmin}"
: "${AZURE_POSTGRES_PASSWORD:?Set AZURE_POSTGRES_PASSWORD}"
: "${AZURE_POSTGRES_DATABASE:=sjma_decidim_production}"
: "${AZURE_POSTGRES_TIER:=Burstable}"
: "${AZURE_POSTGRES_SKU:=Standard_B1ms}"
: "${AZURE_POSTGRES_STORAGE_GB:=32}"
: "${AZURE_STORAGE_ACCOUNT:?Set AZURE_STORAGE_ACCOUNT to a globally unique lowercase storage account name}"
: "${AZURE_STORAGE_SKU:=Standard_LRS}"
: "${AZURE_STORAGE_CONTAINER:=active-storage}"
: "${AZURE_APP_SERVICE_SKU:=F1}"
: "${APP_HOST:=${AZURE_APP_NAME}.azurewebsites.net}"
: "${IMAGE_TAG:=$(git -C "$ROOT_DIR" rev-parse --short HEAD)}"
: "${SECRET_KEY_BASE:=$(openssl rand -hex 64)}"
: "${AZURE_ALLOW_SPONSORED_CREDIT_SPEND:?Set AZURE_ALLOW_SPONSORED_CREDIT_SPEND=true after confirming these resources should consume NGO sponsored credits}"
: "${AZURE_BUDGET_NAME:=sjma-no-pay-guard}"
: "${AZURE_BUDGET_AMOUNT:=1}"
: "${AZURE_BUDGET_EMAIL:=$(az account show --query user.name --output tsv)}"
: "${SYNC_STATUTE_DRAFT_CONTENT:=true}"
: "${SYNC_STATUTE_DRAFT_CONTENT_APPLY:=true}"
: "${ALLOW_PUBLISHED_STATUTE_CONTENT_CHANGE:=false}"

if [[ "$AZURE_ALLOW_SPONSORED_CREDIT_SPEND" != "true" ]]; then
  echo "Refusing to deploy: set AZURE_ALLOW_SPONSORED_CREDIT_SPEND=true to confirm use of sponsored NGO credits." >&2
  exit 64
fi

RAILS_MASTER_KEY="${RAILS_MASTER_KEY:-}"
if [[ -z "$RAILS_MASTER_KEY" && -f "$ROOT_DIR/config/master.key" ]]; then
  RAILS_MASTER_KEY="$(tr -d '\n' < "$ROOT_DIR/config/master.key")"
fi

az group create \
  --name "$AZURE_RESOURCE_GROUP" \
  --location "$AZURE_LOCATION" \
  --output none

SUBSCRIPTION_ID="$(az account show --query id --output tsv)"
BUDGET_BODY="$(mktemp)"
BUDGET_START="$(date -u +%Y-%m-01T00:00:00Z)"
BUDGET_END="$(date -u -d '+1 year' +%Y-%m-01T00:00:00Z)"
cat > "$BUDGET_BODY" <<JSON
{
  "properties": {
    "category": "Cost",
    "amount": ${AZURE_BUDGET_AMOUNT},
    "timeGrain": "Monthly",
    "timePeriod": {
      "startDate": "${BUDGET_START}",
      "endDate": "${BUDGET_END}"
    },
    "notifications": {
      "Actual_GreaterThan_50_Percent": {
        "enabled": true,
        "operator": "GreaterThan",
        "threshold": 50,
        "thresholdType": "Actual",
        "contactEmails": ["${AZURE_BUDGET_EMAIL}"],
        "locale": "en-us"
      },
      "Actual_GreaterThan_90_Percent": {
        "enabled": true,
        "operator": "GreaterThan",
        "threshold": 90,
        "thresholdType": "Actual",
        "contactEmails": ["${AZURE_BUDGET_EMAIL}"],
        "locale": "en-us"
      },
      "Actual_GreaterThan_100_Percent": {
        "enabled": true,
        "operator": "GreaterThan",
        "threshold": 100,
        "thresholdType": "Actual",
        "contactEmails": ["${AZURE_BUDGET_EMAIL}"],
        "locale": "en-us"
      }
    }
  }
}
JSON

az rest \
  --method put \
  --url "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/providers/Microsoft.Consumption/budgets/${AZURE_BUDGET_NAME}?api-version=2023-05-01" \
  --body @"$BUDGET_BODY" \
  --output none
rm -f "$BUDGET_BODY"

if ! az acr show --resource-group "$AZURE_RESOURCE_GROUP" --name "$AZURE_ACR_NAME" --output none 2>/dev/null; then
  az acr create \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --name "$AZURE_ACR_NAME" \
    --sku "$AZURE_ACR_SKU" \
    --admin-enabled false \
    --output none
fi

if az acr repository show-tags \
  --name "$AZURE_ACR_NAME" \
  --repository "$AZURE_APP_NAME" \
  --query "[?@=='${IMAGE_TAG}']" \
  --output tsv 2>/dev/null | grep -qx "$IMAGE_TAG"; then
  echo "Image ${AZURE_APP_NAME}:${IMAGE_TAG} already exists in ACR; skipping build."
else
  az acr build \
    --registry "$AZURE_ACR_NAME" \
    --image "${AZURE_APP_NAME}:${IMAGE_TAG}" \
    "$ROOT_DIR"
fi

if ! az postgres flexible-server show --resource-group "$AZURE_RESOURCE_GROUP" --name "$AZURE_POSTGRES_SERVER" --output none 2>/dev/null; then
  az postgres flexible-server create \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --name "$AZURE_POSTGRES_SERVER" \
    --location "$AZURE_LOCATION" \
    --admin-user "$AZURE_POSTGRES_ADMIN" \
    --admin-password "$AZURE_POSTGRES_PASSWORD" \
    --version 16 \
    --tier "$AZURE_POSTGRES_TIER" \
    --sku-name "$AZURE_POSTGRES_SKU" \
    --storage-size "$AZURE_POSTGRES_STORAGE_GB" \
    --public-access 0.0.0.0 \
    --output none
fi

if ! az postgres flexible-server db show \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --server-name "$AZURE_POSTGRES_SERVER" \
  --name "$AZURE_POSTGRES_DATABASE" \
  --output none 2>/dev/null; then
  az postgres flexible-server db create \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --server-name "$AZURE_POSTGRES_SERVER" \
    --name "$AZURE_POSTGRES_DATABASE" \
    --output none
fi

CLIENT_IP="$(curl -fsS https://api.ipify.org 2>/dev/null || true)"
if [[ -n "$CLIENT_IP" ]]; then
  az postgres flexible-server firewall-rule create \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --server-name "$AZURE_POSTGRES_SERVER" \
    --name AllowLocalRestore \
    --start-ip-address "$CLIENT_IP" \
    --end-ip-address "$CLIENT_IP" \
    --output none
fi

if ! az storage account show --resource-group "$AZURE_RESOURCE_GROUP" --name "$AZURE_STORAGE_ACCOUNT" --output none 2>/dev/null; then
  az storage account create \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --name "$AZURE_STORAGE_ACCOUNT" \
    --location "$AZURE_LOCATION" \
    --sku "$AZURE_STORAGE_SKU" \
    --kind StorageV2 \
    --output none
fi

AZURE_STORAGE_ACCESS_KEY="$(az storage account keys list \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --account-name "$AZURE_STORAGE_ACCOUNT" \
  --query '[0].value' \
  --output tsv)"

az storage container create \
  --account-name "$AZURE_STORAGE_ACCOUNT" \
  --account-key "$AZURE_STORAGE_ACCESS_KEY" \
  --name "$AZURE_STORAGE_CONTAINER" \
  --public-access off \
  --output none

if ! az appservice plan show --resource-group "$AZURE_RESOURCE_GROUP" --name "$AZURE_PLAN_NAME" --output none 2>/dev/null; then
  az appservice plan create \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --name "$AZURE_PLAN_NAME" \
    --is-linux \
    --sku "$AZURE_APP_SERVICE_SKU" \
    --output none
fi

ACR_LOGIN_SERVER="$(az acr show \
  --name "$AZURE_ACR_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query loginServer \
  --output tsv)"

if ! az webapp show --resource-group "$AZURE_RESOURCE_GROUP" --name "$AZURE_APP_NAME" --output none 2>/dev/null; then
  az webapp create \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --plan "$AZURE_PLAN_NAME" \
    --name "$AZURE_APP_NAME" \
    --deployment-container-image-name "${ACR_LOGIN_SERVER}/${AZURE_APP_NAME}:${IMAGE_TAG}" \
    --output none
fi

az webapp config container set \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_APP_NAME" \
  --container-image-name "${ACR_LOGIN_SERVER}/${AZURE_APP_NAME}:${IMAGE_TAG}" \
  --container-registry-url "https://${ACR_LOGIN_SERVER}" \
  --enable-app-service-storage false \
  --output none

WEBAPP_PRINCIPAL_ID="$(az webapp identity assign \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_APP_NAME" \
  --query principalId \
  --output tsv)"

ACR_ID="$(az acr show \
  --name "$AZURE_ACR_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query id \
  --output tsv)"

az role assignment create \
  --assignee "$WEBAPP_PRINCIPAL_ID" \
  --scope "$ACR_ID" \
  --role AcrPull \
  --output none 2>/dev/null || true

az webapp config set \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_APP_NAME" \
  --generic-configurations '{"acrUseManagedIdentityCreds": true}' \
  --output none

DATABASE_URL="postgres://${AZURE_POSTGRES_ADMIN}:${AZURE_POSTGRES_PASSWORD}@${AZURE_POSTGRES_SERVER}.postgres.database.azure.com:5432/${AZURE_POSTGRES_DATABASE}?sslmode=require"

az webapp config appsettings set \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_APP_NAME" \
  --settings \
    WEBSITES_PORT=3000 \
    RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    SECRET_KEY_BASE="$SECRET_KEY_BASE" \
    RAILS_MASTER_KEY="$RAILS_MASTER_KEY" \
    DATABASE_URL="$DATABASE_URL" \
    DECIDIM_APPLICATION_NAME="Societat Joventut Musical d'Albal" \
    DECIDIM_AVAILABLE_LOCALES=ca \
    DECIDIM_DEFAULT_LOCALE=ca \
    DECIDIM_FORCE_SSL=true \
    DECIDIM_SERVICE_WORKER_ENABLED=true \
    DECIDIM_MAILER_SENDER="${DECIDIM_MAILER_SENDER:-no-reply@${APP_HOST}}" \
    STORAGE_PROVIDER=azure \
    AZURE_STORAGE_ACCOUNT_NAME="$AZURE_STORAGE_ACCOUNT" \
    AZURE_STORAGE_ACCESS_KEY="$AZURE_STORAGE_ACCESS_KEY" \
    AZURE_CONTAINER="$AZURE_STORAGE_CONTAINER" \
    RUN_DB_MIGRATIONS=false \
    APPLY_BRANDING_ASSETS=false \
    SYNC_STATUTE_DRAFT_CONTENT="$SYNC_STATUTE_DRAFT_CONTENT" \
    SYNC_STATUTE_DRAFT_CONTENT_APPLY="$SYNC_STATUTE_DRAFT_CONTENT_APPLY" \
    ALLOW_PUBLISHED_STATUTE_CONTENT_CHANGE="$ALLOW_PUBLISHED_STATUTE_CONTENT_CHANGE" \
  --output none

az webapp restart \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_APP_NAME" \
  --output none

cat <<EOF
Azure shell deployment finished.

App URL: https://${APP_HOST}
Image: ${ACR_LOGIN_SERVER}/${AZURE_APP_NAME}:${IMAGE_TAG}
Database URL host: ${AZURE_POSTGRES_SERVER}.postgres.database.azure.com

Next required step: restore the SJMA database dump and ActiveStorage files.
See docs/deployment/azure.md.
EOF
