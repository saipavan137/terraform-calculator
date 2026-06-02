output "app_url" {
  description = "URL to open the calculator in a browser."
  value       = "http://${google_compute_instance.this.network_interface[0].access_config[0].nat_ip}"
}

output "public_ip" {
  description = "Public IP address of the GCP VM."
  value       = google_compute_instance.this.network_interface[0].access_config[0].nat_ip
}

output "instance_id" {
  description = "GCP instance ID."
  value       = google_compute_instance.this.instance_id
}

output "cloud" {
  description = "Cloud provider name."
  value       = "gcp"
}
