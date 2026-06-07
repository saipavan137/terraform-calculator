# GitHub Actions — Terraform CI/CD

## What runs automatically

| Event | Action |
|--------|--------|
| **Pull request** | `fmt` check → `init` → `validate` → **plan** (no apply) |
| **Push to `main`** | Same as above, then **apply** (uses saved plan) |
| **Manual** (Actions tab) | Choose **plan**, **apply**, or **destroy**; pick **clouds**: `aws`, `azure`, or **`both`** (default) |

Workflow file: `.github/workflows/terraform.yml`

Azure setup: see **AZURE.md**

---

## One-time GitHub setup

### 1. Push code to GitHub

```bash
git init
git add .
git commit -m "Add Terraform calculator infrastructure"
git branch -M main
git remote add origin https://github.com/YOUR_USER/YOUR_REPO.git
git push -u origin main
```

### 2. Create S3 backend for state (required for apply in CI)

CI must use **remote state** or every run will try to recreate everything.

1. Create an S3 bucket (e.g. `my-tf-state-bucket-12345`)
2. Optional: DynamoDB table `terraform-locks` for state locking
3. Enable versioning on the bucket (recommended)

### 3. Add GitHub Secrets

Repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

| Secret | Example | Required |
|--------|---------|----------|
| `AWS_ACCESS_KEY_ID` | IAM access key | Yes |
| `AWS_SECRET_ACCESS_KEY` | IAM secret key | Yes |
| `TF_STATE_BUCKET` | `my-tf-state-bucket-12345` | Yes for apply |
| `TF_STATE_KEY` | `terraform-basic-project/terraform.tfstate` | Yes for apply |
| `TF_STATE_REGION` | `us-east-1` | Yes for apply |
| `TF_STATE_DYNAMODB_TABLE` | `terraform-locks` | Optional |
| `AZURE_CREDENTIALS` | JSON from `az ad sp create-for-rbac --sdk-auth` | When deploying Azure |
| `AZURE_ADMIN_PASSWORD` | Strong VM admin password | When deploying Azure |
| `AZURE_SUBSCRIPTION_ID` | Your subscription GUID | When deploying Azure |

Optional repo **Variable** (Settings → Actions → Variables):

| Variable | Value | Purpose |
|----------|-------|---------|
| `ENABLE_AZURE` | `true` | Also deploy Azure on **push to main** (default: AWS only) |

### Deploy AWS + Azure from GitHub

1. Add all secrets above (AWS + Azure + S3 state).
2. Actions → **Terraform** → **Run workflow**.
3. **clouds** = **`both`**, **terraform_action** = **`apply`**.
4. Check the **Outputs** step for `calculator_urls`.

IAM user needs at least: EC2, VPC/security groups, and S3 state bucket access.

### 4. (Recommended) Protect `main` branch

- Require pull request before merging
- Require status check: **Terraform**

### 5. (Optional) Environment approval for apply

Settings → **Environments** → **production** → **Required reviewers**

The workflow uses the `production` environment when applying on `main` or destroying manually.

### Destroy from GitHub (manual only)

1. Actions → **Terraform** → **Run workflow**
2. Branch: `main`, action: **destroy**
3. Review the **Plan** job (shows resources to remove)
4. Approve **Destroy** if `production` environment requires reviewers
5. **Verify empty state** step should print nothing (no resources left)

Destroy never runs on push — only when you choose it manually.

---

## Local init with same remote state

```bash
terraform init -backend-config=backend.hcl
```

Copy `backend.hcl.example` → `backend.hcl` and fill in your bucket name.

---

## GCP (optional)

Azure is in `azure.tf`. For GCP only:

1. Copy `multi_cloud.tf.example` → `multi_cloud.tf`
2. Copy `providers.gcp.tf.example` → `providers.gcp.tf`
3. Set `enable_gcp = true` in `terraform.tfvars`

---

## Commit `.terraform.lock.hcl`

The lock file is **committed** so CI uses the same provider versions as your laptop.
