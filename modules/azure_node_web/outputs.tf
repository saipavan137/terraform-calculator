output "app_url" {
  description = "URL to open the calculator in a browser."
  value       = "http://${azurerm_public_ip.this.ip_address}"
}

output "public_ip" {
  description = "Public IP address of the Azure VM."
  value       = azurerm_public_ip.this.ip_address
}
