# Merged URL map when multiple clouds are active (local / full deploy).
# Omitted in CI when only one cloud is selected — see workflow "Select active cloud configs".

output "calculator_urls" {
  description = "All active calculator URLs by cloud."
  value = merge(
    var.enable_aws ? { aws = module.aws_app[0].app_url } : {},
    var.enable_azure ? { azure = module.azure_app[0].app_url } : {},
    var.enable_gcp ? { gcp = module.gcp_app[0].app_url } : {},
  )
}
