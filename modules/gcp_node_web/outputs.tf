output "app_url" {
  description = "URL to open the calculator in a browser."
  value       = "http://${google_compute_address.this.address}"
}

output "public_ip" {
  description = "Public IP address of the GCE VM."
  value       = google_compute_address.this.address
}
