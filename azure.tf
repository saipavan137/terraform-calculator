provider "azurerm" {
  features {}

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
