locals {
  shared_files = "${path.module}/../shared/files"
  install_script = templatefile("${path.module}/../shared/scripts/install_ubuntu.sh.tpl", {
    app_port       = var.app_port
    index_html_b64 = filebase64("${local.shared_files}/index.html")
    server_js_b64  = filebase64("${local.shared_files}/server.js")
  })
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_network" "this" {
  name                    = "${var.name_prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = "${var.name_prefix}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.this.id
}

resource "google_compute_address" "this" {
  name   = "${var.name_prefix}-ip"
  region = var.region
}

resource "google_compute_firewall" "http" {
  name    = "${var.name_prefix}-allow-http"
  network = google_compute_network.this.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = [tostring(var.app_port)]
  }

  source_ranges = var.http_cidr_blocks
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.name_prefix}-allow-ssh"
  network = google_compute_network.this.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_cidr_blocks
  target_tags   = ["ssh-server"]
}

resource "google_compute_instance" "this" {
  name         = "${var.name_prefix}-vm"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["http-server", "ssh-server"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = var.boot_disk_size_gb
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.this.id

    access_config {
      nat_ip = google_compute_address.this.address
    }
  }

  metadata_startup_script = local.install_script
}
