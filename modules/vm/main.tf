resource "google_compute_instance" "vm_instance" {
  project      = var.project_id
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = var.allow_stopping_for_update

  tags = ["${var.instance_name}"]

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
      type  = "pd-ssd"
    }
  }

  dynamic "attached_disk" {
    for_each = var.attached_disk_source != "" ? [1] : []
    content {
      source      = var.attached_disk_source
      device_name = var.attached_disk_device_name
    }
  }

  network_interface {
    network = var.network_name
    subnetwork = var.subnetwork_name

    access_config {
      network_tier = "STANDARD"
    }
  }

  metadata = {
    role = join(",", var.roles)
    user-data = var.ignition_config != "" ? var.ignition_config : <<-EOF
      #cloud-config
      chpasswd:
        list: |
          ${var.user}:${var.password}
        expire: false
      ssh_pwauth: true
    EOF
  }


  metadata_startup_script = var.metadata_startup_script

  service_account {
        email  = var.service_account_email
        scopes = ["cloud-platform"]
    }

}