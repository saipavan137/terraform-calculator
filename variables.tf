# ── Cloud toggles (turn on as you add credentials) ──────────────────────────

variable "enable_aws" {
  description = "Deploy calculator on AWS EC2."
  type        = bool
  default     = true
}

variable "enable_azure" {
  description = "Deploy calculator on Azure VM."
  type        = bool
  default     = false
}

variable "enable_gcp" {
  description = "Deploy calculator on GCP Compute Engine."
  type        = bool
  default     = false
}

variable "app_port" {
  description = "HTTP port for the calculator (all clouds)."
  type        = number
  default     = 80
}

# ── AWS ─────────────────────────────────────────────────────────────────────

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "aws_ami" {
  description = "AMI ID (Amazon Linux 2023 recommended)."
  type        = string
  default     = "ami-05ffe3c48a9991133"
}

variable "aws_instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "aws_instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
  default     = "Terraform-EC2"
}

variable "aws_subnet_id" {
  description = "Optional subnet ID. Leave null to use the first subnet in the default VPC."
  type        = string
  default     = null
  nullable    = true
}

# ── Azure ───────────────────────────────────────────────────────────────────

variable "azure_subscription_id" {
  description = "Azure subscription ID (set when enable_azure = true)."
  type        = string
  default     = ""
}

variable "azure_tenant_id" {
  description = "Azure AD tenant ID (optional; az login can infer)."
  type        = string
  default     = ""
}

variable "azure_client_id" {
  description = "Service principal client ID (optional; az login can infer)."
  type        = string
  default     = ""
}

variable "azure_client_secret" {
  description = "Service principal secret (optional)."
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_location" {
  description = "Azure region."
  type        = string
  default     = "eastus"
}

variable "azure_name_prefix" {
  description = "Prefix for Azure resource names."
  type        = string
  default     = "tf-calc"
}

variable "azure_vm_size" {
  description = "Azure VM size."
  type        = string
  default     = "Standard_B1ms"
}

variable "azure_admin_password" {
  description = "VM admin password (demo/lab only)."
  type        = string
  sensitive   = true
  default     = "TerraformCalc-Demo2024!"
}

# ── GCP ─────────────────────────────────────────────────────────────────────

variable "gcp_project_id" {
  description = "GCP project ID (required when enable_gcp = true)."
  type        = string
  default     = ""
}

variable "gcp_region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone for the VM."
  type        = string
  default     = "us-central1-a"
}

variable "gcp_name_prefix" {
  description = "Prefix for GCP firewall rule names."
  type        = string
  default     = "tf-calc"
}

variable "gcp_machine_type" {
  description = "GCP machine type."
  type        = string
  default     = "e2-micro"
}

variable "gcp_instance_name" {
  description = "GCP compute instance name."
  type        = string
  default     = "tf-calc-vm"
}
