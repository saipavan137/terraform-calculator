variable "ami" {
  description = "AMI ID for the EC2 instance (Amazon Linux 2023 recommended)."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "app_port" {
  description = "Port the Node.js app listens on."
  type        = number
  default     = 80
}

variable "instance_name" {
  description = "Value for the Name tag on the EC2 instance."
  type        = string
  default     = "Terraform-EC2"
}

variable "security_group_name" {
  description = "Name of the security group."
  type        = string
  default     = "tf-basic-node-web"
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

variable "user_data_replace_on_change" {
  description = "Replace the instance when user_data changes."
  type        = bool
  default     = true
}
