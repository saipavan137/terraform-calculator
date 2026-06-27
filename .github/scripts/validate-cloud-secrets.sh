#!/usr/bin/env bash
# Fail fast when a selected cloud is missing required GitHub secrets.
set -euo pipefail

missing=0

if [ "${TF_VAR_enable_azure:-false}" = "true" ]; then
  if [ -z "${TF_VAR_azure_subscription_id:-}" ]; then
    echo "::error::Azure is enabled but AZURE_SUBSCRIPTION_ID secret is not set."
    missing=1
  fi
  if [ -z "${AZURE_CREDENTIALS:-}" ]; then
    echo "::error::Azure is enabled but AZURE_CREDENTIALS secret is not set."
    missing=1
  fi
fi

if [ "${TF_VAR_enable_gcp:-false}" = "true" ]; then
  if [ -z "${TF_VAR_gcp_project_id:-}" ]; then
    echo "::error::GCP is enabled but GCP_PROJECT_ID secret is not set."
    missing=1
  fi
  if [ -z "${GCP_SA_KEY:-}" ]; then
    echo "::error::GCP is enabled but GCP_SA_KEY secret is not set. Add the full JSON key for a GCP service account."
    missing=1
  fi
fi

if [ "${TF_VAR_enable_aws:-false}" = "true" ] && [ -z "${AWS_ACCESS_KEY_ID:-}" ]; then
  echo "::error::AWS is enabled but AWS_ACCESS_KEY_ID secret is not set."
  missing=1
fi

if [ -n "${TF_STATE_BUCKET:-}" ] && [ -z "${AWS_ACCESS_KEY_ID:-}" ]; then
  echo "::error::TF_STATE_BUCKET is set (S3 remote state) but AWS_ACCESS_KEY_ID is missing. AWS keys are required to read/write state even for Azure-only or GCP-only runs."
  missing=1
fi

if [ "$missing" -ne 0 ]; then
  exit 1
fi

echo "Cloud secrets validated."
