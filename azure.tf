provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.azure_subscription_id != "" ? var.azure_subscription_id : null
}

module "azure_app" {
  count  = var.enable_azure ? 1 : 0
  source = "./modules/azure_node_web"

  location       = var.azure_location
  name_prefix    = var.azure_name_prefix
  vm_size        = var.azure_vm_size
  app_port       = var.app_port
  admin_password = var.azure_admin_password
}

output "azure_app_url" {
  description = "Calculator URL on Azure (null if disabled)."
  value       = var.enable_azure ? module.azure_app[0].app_url : null
}

output "azure_public_ip" {
  description = "Azure VM public IP."
  value       = var.enable_azure ? module.azure_app[0].public_ip : null
}
