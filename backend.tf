# Remote state for CI/CD and team use. Bucket/DynamoDB values come from
# terraform init -backend-config=... (see .github/workflows/terraform.yml)
# or backend.hcl locally.
terraform {
  backend "s3" {}
}
