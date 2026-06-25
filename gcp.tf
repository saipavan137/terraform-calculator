provider "google" {
  project = var.gcp_project_id != "" ? var.gcp_project_id : null
  region  = var.gcp_region
}

module "gcp_app" {
  count  = var.enable_gcp ? 1 : 0
  source = "./modules/gcp_node_web"

  project_id   = var.gcp_project_id
  region       = var.gcp_region
  zone         = var.gcp_zone
  name_prefix  = var.gcp_name_prefix
  machine_type = var.gcp_machine_type
  app_port     = var.app_port
}

output "gcp_app_url" {
  description = "Calculator URL on GCP (null if disabled)."
  value       = var.enable_gcp ? module.gcp_app[0].app_url : null
}

output "gcp_public_ip" {
  description = "GCP VM public IP."
  value       = var.enable_gcp ? module.gcp_app[0].public_ip : null
}
