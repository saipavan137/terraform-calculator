output "aws_app_url" {
  description = "Calculator URL on AWS (null if disabled)."
  value       = var.enable_aws ? module.aws_app[0].app_url : null
}

output "aws_public_ip" {
  description = "AWS EC2 public IP."
  value       = var.enable_aws ? module.aws_app[0].public_ip : null
}

output "azure_app_url" {
  description = "Calculator URL on Azure (null if disabled)."
  value       = var.enable_azure ? module.azure_app[0].app_url : null
}

output "azure_public_ip" {
  description = "Azure VM public IP."
  value       = var.enable_azure ? module.azure_app[0].public_ip : null
}

output "calculator_urls" {
  description = "All active calculator URLs by cloud."
  value = merge(
    var.enable_aws ? { aws = module.aws_app[0].app_url } : {},
    var.enable_azure ? { azure = module.azure_app[0].app_url } : {},
  )
}
