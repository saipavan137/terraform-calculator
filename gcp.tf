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
