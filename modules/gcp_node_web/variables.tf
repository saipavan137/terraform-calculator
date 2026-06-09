variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "GCP region (e.g. us-central1)."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for the VM (e.g. us-central1-a)."
  type        = string
  default     = "us-central1-a"
}

variable "name_prefix" {
  description = "Prefix for GCP resource names."
  type        = string
  default     = "tf-calc"
}

variable "machine_type" {
  description = "GCE machine type."
  type        = string
  default     = "e2-micro"
}

variable "app_port" {
  description = "Port the Node.js app listens on."
  type        = number
  default     = 80
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB."
  type        = number
  default     = 10
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
