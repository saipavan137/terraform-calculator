#!/usr/bin/env bash
# Resolve TF_VAR_enable_* flags for GitHub Actions.
# Usage: cloud-toggles.sh <event> <clouds_input> [enable_all_clouds] [enable_azure] [enable_gcp]
set -euo pipefail

event="${1:-workflow_dispatch}"
selection="${2:-aws}"
enable_all_clouds="${3:-false}"
enable_azure_var="${4:-false}"
enable_gcp_var="${5:-false}"

enable_aws=false
enable_azure=false
enable_gcp=false

if [ "$event" = "workflow_dispatch" ]; then
  case "$selection" in
    all | all-three)
      enable_aws=true
      enable_azure=true
      enable_gcp=true
      ;;
    aws)
      enable_aws=true
      ;;
    azure)
      enable_azure=true
      ;;
    gcp)
      enable_gcp=true
      ;;
    aws-azure)
      enable_aws=true
      enable_azure=true
      ;;
    aws-gcp)
      enable_aws=true
      enable_gcp=true
      ;;
    azure-gcp)
      enable_azure=true
      enable_gcp=true
      ;;
    *)
      echo "::error::Unknown clouds selection: $selection"
      exit 1
      ;;
  esac
else
  # push / pull_request — default AWS; opt in to more via repo variables
  enable_aws=true
  if [ "$enable_all_clouds" = "true" ]; then
    enable_azure=true
    enable_gcp=true
  else
    [ "$enable_azure_var" = "true" ] && enable_azure=true
    [ "$enable_gcp_var" = "true" ] && enable_gcp=true
  fi
fi

echo "TF_VAR_enable_aws=$enable_aws"
echo "TF_VAR_enable_azure=$enable_azure"
echo "TF_VAR_enable_gcp=$enable_gcp"

echo "enable_aws=$enable_aws"
echo "enable_azure=$enable_azure"
echo "enable_gcp=$enable_gcp"
