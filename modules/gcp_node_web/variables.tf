variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for the VM."
  type        = string
  default     = "us-central1-a"
}

variable "name_prefix" {
  description = "Prefix for GCP resource names."
  type        = string
  default     = "tf-calc"
}

variable "machine_type" {
  description = "GCP machine type."
  type        = string
  default     = "e2-micro"
}

variable "app_port" {
  description = "Port the Node.js app listens on."
  type        = number
  default     = 80
}

variable "instance_name" {
  description = "Compute instance name."
  type        = string
  default     = "tf-calc-vm"
}

variable "http_cidr_blocks" {
  description = "CIDR blocks allowed to reach the app port."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
