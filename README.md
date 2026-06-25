# Multi-Cloud Calculator (Terraform)

Deploy a small web app on **AWS**, **Azure**, and **GCP** with one Terraform project. Each cloud gets its own VM running a Node.js server that serves a calculator page in the browser.

Turn clouds on or off with `enable_*` flags — use one cloud today and add others when you have credentials.

---

## What gets created

| Cloud | Resources | Default VM size |
|-------|-----------|-----------------|
| **AWS** | EC2 instance, security group | `t2.micro` |
| **Azure** | Linux VM, VNet, subnet, NSG, public IP | `Standard_D2s_v3` |
| **GCP** | Compute Engine VM, VPC, subnet, firewall rules, static IP | `e2-micro` |

Each VM installs Node.js on first boot and runs a systemd service on port **80**.

---

## Project layout

```text
TerraformBasicProject/
├── main.tf                 # AWS module
├── azure.tf                # Azure provider + module
├── gcp.tf                  # GCP provider + module
├── providers.tf            # AWS provider
├── variables.tf            # All input variables
├── outputs.tf              # URLs and IPs per cloud
├── backend.tf              # S3 remote state (optional)
├── terraform.tfvars.example
│
└── modules/
    ├── aws_node_web/       # EC2 + security group
    ├── azure_node_web/     # Azure VM + networking
    ├── gcp_node_web/       # GCE VM + networking
    └── shared/
        ├── files/          # index.html, server.js
        └── scripts/        # Ubuntu startup script (Azure/GCP)
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) **>= 1.2**
- Cloud credentials for each provider you enable

| Cloud | Local setup |
|-------|-------------|
| **AWS** | `aws configure` or `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` |
| **Azure** | `az login` and your subscription ID |
| **GCP** | [Google Cloud SDK](https://cloud.google.com/sdk/docs/install), then `gcloud auth application-default login` |

**GCP only:** enable the Compute Engine API in your project:

```bash
gcloud services enable compute.googleapis.com --project=YOUR_PROJECT_ID
```

---

## Quick start

### 1. Configure variables

```bash
copy terraform.tfvars.example terraform.tfvars   # Windows
# cp terraform.tfvars.example terraform.tfvars   # macOS/Linux
```

Edit `terraform.tfvars` — set `enable_*` flags and cloud-specific values (see [Variables](#variables)).

### 2. Initialize

**Local state** (simplest for learning):

```bash
terraform init -backend=false
```

**Remote state** (S3 bucket — create `backend.hcl` with your bucket details):

```bash
terraform init -backend-config=backend.hcl
```

### 3. Plan and apply

```bash
terraform plan
terraform apply
```

### 4. Open the app

```bash
terraform output calculator_urls
```

Open any URL in your browser. Example:

```bash
curl -I http://YOUR_PUBLIC_IP
```

**GCP note:** the VM runs a startup script (apt + Node.js install). The URL may take **5–10 minutes** to respond after the first apply.

---

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `enable_aws` | Deploy on AWS | `true` |
| `enable_azure` | Deploy on Azure | `false` |
| `enable_gcp` | Deploy on GCP | `false` |
| `app_port` | HTTP port (all clouds) | `80` |
| `aws_region` | AWS region | `us-east-1` |
| `aws_instance_type` | EC2 instance type | `t2.micro` |
| `azure_subscription_id` | Azure subscription ID | `""` |
| `azure_location` | Azure region | `westus2` |
| `azure_name_prefix` | Azure resource name prefix | `tf-calc` |
| `gcp_project_id` | GCP project ID | `""` |
| `gcp_region` | GCP region | `us-central1` |
| `gcp_zone` | GCP zone | `us-central1-a` |
| `gcp_machine_type` | GCE machine type | `e2-micro` |

See `terraform.tfvars.example` for a full sample file.

---

## Cloud-specific setup

### AWS

```bash
aws configure
```

In `terraform.tfvars`:

```hcl
enable_aws = true
aws_region = "us-east-1"
```

### Azure

```bash
az login
az account show --query id -o tsv   # subscription ID
```

In `terraform.tfvars`:

```hcl
enable_azure = true
azure_subscription_id = "your-subscription-id"
azure_location        = "westus2"
```

### GCP

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
gcloud services enable compute.googleapis.com
```

If the browser opens in the wrong app, use manual login:

```bash
gcloud auth login --no-launch-browser --update-adc
```

In `terraform.tfvars`:

```hcl
enable_gcp = true
gcp_project_id = "your-project-id"
gcp_region     = "us-central1"
gcp_zone       = "us-central1-a"
```

---

## Outputs

| Output | Description |
|--------|-------------|
| `aws_app_url` | Calculator URL on AWS |
| `azure_app_url` | Calculator URL on Azure |
| `gcp_app_url` | Calculator URL on GCP |
| `calculator_urls` | Map of all active URLs |
| `*_public_ip` | Public IP per cloud |

---

## Verify it works

After apply (wait a few minutes on GCP):

```bash
terraform output -json calculator_urls
```

```bash
curl http://$(terraform output -raw aws_public_ip)
curl http://$(terraform output -raw azure_public_ip)
curl http://$(terraform output -raw gcp_public_ip)
```

You should get HTTP **200** and an HTML page titled **Calculator**.

---

## Destroy

Remove all resources:

```bash
terraform destroy
```

Or auto-approve:

```bash
terraform destroy -auto-approve
```

---

## GitHub Actions (optional)

CI is defined in `.github/workflows/terraform.yml`. It runs `plan` on PRs and can `apply` / `destroy` via workflow dispatch.

Required secrets for full multi-cloud CI:

- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` — **always required when `TF_STATE_BUCKET` is set** (S3 remote state lives in AWS, even for Azure-only or GCP-only deploys)
- `AZURE_CREDENTIALS`, `AZURE_SUBSCRIPTION_ID`
- `GCP_SA_KEY`, `GCP_PROJECT_ID`
- `TF_STATE_BUCKET` (+ optional DynamoDB lock table)

Set repo variable `ENABLE_AZURE=true` / `ENABLE_GCP=true` to include those clouds on push to `main`.

---

## Security

- **HTTP (port 80)** is open to the internet so you can open the app in a browser.
- **SSH (port 22)** is also allowed on all three clouds for troubleshooting (demo/lab use).
- `terraform.tfvars` and `backend.hcl` are gitignored — never commit secrets.

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| GCP URL times out right after apply | Wait 5–10 min for startup script; check with `gcloud compute ssh tf-calc-vm --zone=us-central1-a --command="sudo systemctl status nodeapp"` |
| Azure auth errors | Run `az login` and confirm `azure_subscription_id` |
| GCP `Permission denied` | Run `gcloud auth application-default login` |
| `API compute.googleapis.com not enabled` | Enable Compute Engine API in GCP Console or via `gcloud services enable` |

---

## License

Demo / learning project. Use at your own cost in your cloud accounts.
