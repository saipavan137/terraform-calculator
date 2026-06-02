locals {
  shared_files = "${path.module}/../shared/files"
  install_script = templatefile("${path.module}/../shared/scripts/install_ubuntu.sh.tpl", {
    app_port       = var.app_port
    index_html_b64 = filebase64("${local.shared_files}/index.html")
    server_js_b64  = filebase64("${local.shared_files}/server.js")
  })
}

resource "google_compute_firewall" "web" {
  name    = "${var.name_prefix}-allow-web"
  project = var.project_id
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [tostring(var.app_port)]
  }

  source_ranges = var.http_cidr_blocks
  target_tags   = ["calculator-web"]
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.name_prefix}-allow-ssh"
  project = var.project_id
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_cidr_blocks
  target_tags   = ["calculator-web"]
}

resource "google_compute_instance" "this" {
  name         = var.instance_name
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type

  tags = ["calculator-web"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata_startup_script = local.install_script
}
