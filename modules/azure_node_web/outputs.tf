output "app_url" {
  description = "URL to open the calculator in a browser."
  value       = "http://${azurerm_public_ip.this.ip_address}"
}

output "public_ip" {
  description = "Public IP address of the Azure VM."
  value       = azurerm_public_ip.this.ip_address
}

output "instance_id" {
  description = "Azure VM resource ID."
  value       = azurerm_linux_virtual_machine.this.id
}

output "resource_group" {
  description = "Azure resource group name."
  value       = azurerm_resource_group.this.name
}

output "cloud" {
  description = "Cloud provider name."
  value       = "azure"
}
