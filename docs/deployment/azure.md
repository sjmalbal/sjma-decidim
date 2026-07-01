# Azure Deployment

This app is a Decidim 0.29.7 Rails application. The production deployment path is:

- Azure Container Registry for the app image.
- Azure App Service for Linux containers.
- Azure Database for PostgreSQL Flexible Server.
- Azure Blob Storage for ActiveStorage uploads.

The generic `db/seeds.rb` should not be used for publication because it creates Decidim demo content. Publish from the current SJMA database dump instead.

## 1. Export local state

From `/home/dani/sjma/sjma_decidim`:

```bash
script/azure/export_local_state.sh
```

This creates ignored artifacts under `tmp/azure/`:

- a custom PostgreSQL dump of `sjma_decidim_development`
- a tarball of local ActiveStorage files

## 2. Provision Azure resources

Install and log in to Azure CLI, then choose globally unique names:

```bash
az login

export AZURE_RESOURCE_GROUP=sjma-decidim-rg
export AZURE_LOCATION=westeurope
export AZURE_APP_NAME=sjma-decidim
export AZURE_ACR_NAME=<unique-lowercase-acr-name>
export AZURE_POSTGRES_SERVER=<unique-lowercase-postgres-name>
export AZURE_POSTGRES_PASSWORD='<strong-password>'
export AZURE_STORAGE_ACCOUNT=<uniquelowercasestorage>
export APP_HOST="${AZURE_APP_NAME}.azurewebsites.net"
export AZURE_ALLOW_SPONSORED_CREDIT_SPEND=true
export AZURE_BUDGET_AMOUNT=1
export AZURE_BUDGET_EMAIL=secretaria@sjmalbal.com

script/azure/deploy.sh
```

The script creates a monthly cost budget alert first, then builds the image in ACR, creates the web app, configures managed identity image pulls, writes the required Rails/Decidim app settings, and adds a PostgreSQL firewall rule for the current public IP when it can detect one.

Default SKUs are intentionally the smallest/free-oriented options:

- App Service plan: `F1`
- Azure Container Registry: `Basic`
- PostgreSQL Flexible Server: `Burstable` / `Standard_B1ms` / `32 GB`
- Storage account: `Standard_LRS`

ACR and PostgreSQL can still consume sponsored Azure credits, so the script refuses to run unless `AZURE_ALLOW_SPONSORED_CREDIT_SPEND=true` is set.

## 3. Restore the database

Use the dump produced in step 1:

```bash
script/azure/restore_database.sh tmp/azure/<dump-file>.dump
```

The restore helper also rewrites the Decidim organization host from `localhost` to `$APP_HOST` and changes restored ActiveStorage blobs from the local disk service to the Azure service.

## 4. Upload ActiveStorage files

If the storage tarball was moved elsewhere, extract it first so a `storage/` folder is available.

```bash
script/azure/upload_active_storage.sh \
  "$AZURE_STORAGE_ACCOUNT" \
  active-storage \
  storage
```

This uploads each local disk object using its ActiveStorage key, which is what the Azure service expects.

## 5. Restart and verify

```bash
az webapp restart \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_APP_NAME"

az webapp log tail \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_APP_NAME"
```

Check:

- `https://$APP_HOST`
- `https://$APP_HOST/processes/modificacio-estatutaria-2022-2026/f/7/proposals`
- `https://$APP_HOST/system`

## Production settings still needed

Configure SMTP before sending production mail:

- `SMTP_USERNAME`
- `SMTP_PASSWORD`
- `SMTP_ADDRESS`
- `SMTP_DOMAIN`
- `SMTP_PORT`
- `SMTP_STARTTLS_AUTO`
- `SMTP_AUTHENTICATION`

If member DNI login must remain stable across environments, set `SJMA_DNI_HMAC_SECRET` to the same value used for the local import.

## CI/CD from GitHub

The workflow at `.github/workflows/deploy-production.yml` deploys every push to `main`:

- logs into Azure with GitHub OIDC
- builds the container in ACR
- points the App Service production slot to the new image
- restarts the App Service

After the repository has a GitHub remote, configure OIDC and the required GitHub secrets/variables:

```bash
script/azure/setup_github_oidc.sh <owner/repo>
```

This creates a Microsoft Entra app registration with a federated credential for `refs/heads/main`, grants it `Contributor` on this app's resource group, and writes these GitHub settings:

- secrets: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`
- variables: `AZURE_RESOURCE_GROUP`, `AZURE_ACR_NAME`, `AZURE_APP_NAME`
