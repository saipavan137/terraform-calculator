# Azure setup

Azure is enabled with `enable_azure = true` in `terraform.tfvars`. The module lives in `modules/azure_node_web/` and is wired in `azure.tf`.

## Local (interactive login)

```powershell
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

copy terraform.tfvars.example terraform.tfvars
# Set enable_azure = true and azure_subscription_id

terraform init -upgrade
terraform plan
terraform apply
terraform output azure_app_url
```

## Local (service principal)

Set environment variables:

```powershell
$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_TENANT_ID       = "your-tenant-id"
$env:ARM_CLIENT_ID       = "your-client-id"
$env:ARM_CLIENT_SECRET   = "your-client-secret"
```

## Create a service principal for GitHub Actions

```powershell
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"

az ad sp create-for-rbac `
  --name "terraform-calculator-github" `
  --role "Contributor" `
  --scopes "/subscriptions/YOUR_SUBSCRIPTION_ID" `
  --sdk-auth
```

Copy the **entire JSON output** into GitHub secret **`AZURE_CREDENTIALS`**.

Also add:

| Secret | Purpose |
|--------|---------|
| `AZURE_ADMIN_PASSWORD` | VM admin password (maps to `TF_VAR_azure_admin_password`) |

Optional repo **Variables** (Settings → Actions → Variables):

| Variable | Example | Purpose |
|----------|---------|---------|
| `TF_VAR_enable_azure` | `true` | Deploy Azure in CI |
| `TF_VAR_enable_aws` | `false` | Skip AWS when Azure-only |

Or pass cloud toggles when using **Run workflow** (see workflow inputs).

## GitHub Actions

1. Add secrets `AZURE_CREDENTIALS` and `AZURE_ADMIN_PASSWORD`
2. Actions → **Terraform** → **Run workflow**
3. Set **Enable Azure** = true (and **Enable AWS** = false if Azure-only)
4. Choose **apply**

## Destroy Azure only

Set `enable_aws = false`, `enable_azure = true` in tfvars (or workflow inputs), then **Run workflow → destroy**.

## Resources created

- Resource group, VNet, subnet, public IP, NSG, NIC, Linux VM (Ubuntu 22.04)
- Calculator installed via `custom_data` (same app as AWS)
