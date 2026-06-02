variable "location" {
  description = "Azure region (e.g. eastus)."
  type        = string
  default     = "eastus"
}

variable "name_prefix" {
  description = "Prefix for Azure resource names."
  type        = string
  default     = "tf-calc"
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
  default     = "Standard_B1s"
}

variable "app_port" {
  description = "Port the Node.js app listens on."
  type        = number
  default     = 80
}

variable "admin_username" {
  description = "Admin username for the Linux VM."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the Linux VM (demo only; prefer SSH in production)."
  type        = string
  sensitive   = true
  default     = "TerraformCalc-Demo2024!"
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
