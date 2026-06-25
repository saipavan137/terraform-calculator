#!/usr/bin/env bash
# Remove Terraform files for clouds that are not enabled in this run.
set -euo pipefail

enable_aws="${TF_VAR_enable_aws:-false}"
enable_azure="${TF_VAR_enable_azure:-false}"
enable_gcp="${TF_VAR_enable_gcp:-false}"

enabled=0
[ "$enable_aws" = "true" ] && enabled=$((enabled + 1))
[ "$enable_azure" = "true" ] && enabled=$((enabled + 1))
[ "$enable_gcp" = "true" ] && enabled=$((enabled + 1))

if [ "$enable_aws" != "true" ]; then
  rm -f providers.tf outputs.aws.tf
  sed -i '/module "aws_app"/,/^}/d' main.tf
  sed -i '/aws = {/,/}/d' main.tf
fi

if [ "$enable_azure" != "true" ]; then
  rm -f azure.tf
  sed -i '/azurerm = {/,/}/d' main.tf
fi

if [ "$enable_gcp" != "true" ]; then
  rm -f gcp.tf
  sed -i '/google = {/,/}/d' main.tf
fi

if [ "$enabled" -lt 2 ]; then
  rm -f outputs.urls.tf
fi

echo "Active clouds: aws=$enable_aws azure=$enable_azure gcp=$enable_gcp"
echo "Active .tf files:"
ls -1 *.tf
echo "--- main.tf (providers) ---"
sed -n '1,20p' main.tf
