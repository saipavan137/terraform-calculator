terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

module "aws_app" {
  count  = var.enable_aws ? 1 : 0
  source = "./modules/aws_node_web"

  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  app_port      = var.app_port
  instance_name = var.aws_instance_name
  subnet_id     = var.aws_subnet_id
}
