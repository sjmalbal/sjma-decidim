#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOCAL_DEPLOY_ENV="$ROOT_DIR/tmp/azure/last-deploy.env"

if [[ -f "$LOCAL_DEPLOY_ENV" ]]; then
  # shellcheck disable=SC1090
  source "$LOCAL_DEPLOY_ENV"
fi

REPO="${1:-}"
if [[ -z "$REPO" ]]; then
  REPO="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || true)"
fi

if [[ -z "$REPO" ]]; then
  echo "Usage: $0 <github-owner/repo>" >&2
  echo "No git remote is configured, so the GitHub repository cannot be inferred." >&2
  exit 64
fi

: "${AZURE_RESOURCE_GROUP:?Set AZURE_RESOURCE_GROUP}"
: "${AZURE_APP_NAME:?Set AZURE_APP_NAME}"
: "${AZURE_ACR_NAME:?Set AZURE_ACR_NAME}"

SUBSCRIPTION_ID="$(az account show --query id --output tsv)"
TENANT_ID="$(az account show --query tenantId --output tsv)"
APP_DISPLAY_NAME="sjma-decidim-github-${REPO//\//-}"
SCOPE="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${AZURE_RESOURCE_GROUP}"

APP_ID="$(az ad app list --display-name "$APP_DISPLAY_NAME" --query '[0].appId' --output tsv)"
if [[ -z "$APP_ID" ]]; then
  APP_ID="$(az ad app create --display-name "$APP_DISPLAY_NAME" --query appId --output tsv)"
fi

SP_ID="$(az ad sp list --filter "appId eq '${APP_ID}'" --query '[0].id' --output tsv)"
if [[ -z "$SP_ID" ]]; then
  SP_ID="$(az ad sp create --id "$APP_ID" --query id --output tsv)"
fi

az role assignment create \
  --assignee "$SP_ID" \
  --role Contributor \
  --scope "$SCOPE" \
  --output none 2>/dev/null || true

FEDERATED_NAME="main-branch"
FEDERATED_EXISTS="$(az ad app federated-credential list \
  --id "$APP_ID" \
  --query "[?name=='${FEDERATED_NAME}'].name | [0]" \
  --output tsv)"

if [[ -z "$FEDERATED_EXISTS" ]]; then
  FEDERATED_BODY="$(mktemp)"
  cat > "$FEDERATED_BODY" <<JSON
{
  "name": "${FEDERATED_NAME}",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:${REPO}:ref:refs/heads/main",
  "description": "GitHub Actions main branch deploy for ${REPO}",
  "audiences": [
    "api://AzureADTokenExchange"
  ]
}
JSON

  az ad app federated-credential create \
    --id "$APP_ID" \
    --parameters "$FEDERATED_BODY" \
    --output none
  rm -f "$FEDERATED_BODY"
fi

gh secret set AZURE_CLIENT_ID --repo "$REPO" --body "$APP_ID"
gh secret set AZURE_TENANT_ID --repo "$REPO" --body "$TENANT_ID"
gh secret set AZURE_SUBSCRIPTION_ID --repo "$REPO" --body "$SUBSCRIPTION_ID"

gh variable set AZURE_RESOURCE_GROUP --repo "$REPO" --body "$AZURE_RESOURCE_GROUP"
gh variable set AZURE_ACR_NAME --repo "$REPO" --body "$AZURE_ACR_NAME"
gh variable set AZURE_APP_NAME --repo "$REPO" --body "$AZURE_APP_NAME"

printf 'Configured GitHub OIDC deploy credentials for %s\n' "$REPO"
printf 'Azure app registration client ID: %s\n' "$APP_ID"
