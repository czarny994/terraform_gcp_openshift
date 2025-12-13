resource "google_compute_instance" "vm_instance" {
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
          ocp:${var.ocp_password}
        expire: false
      ssh_pwauth: true
    EOF
  }


  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -euxo pipefail
    
    LOGFILE="/var/log/startup-script.log"
    exec > >(tee -a $LOGFILE) 2>&1
    
    echo "=== Startup script started at $(date) ==="
    logger -t startup-script "Startup script execution started"
    
    # Check if python3 is already installed
    if ! rpm -q python3 &>/dev/null; then
      echo "Python3 not found. Installing..."
      logger -t startup-script "Installing python3 via rpm-ostree"
      sudo rpm-ostree install python3 --idempotent
      logger -t startup-script "Python3 installed. Rebooting system..."
      sudo systemctl reboot
    else
      echo "Python3 is already installed: $(python3 --version)"
      logger -t startup-script "Python3 already installed, skipping installation"
    fi
    
    echo "=== Startup script completed at $(date) ==="
    logger -t startup-script "Startup script execution completed"
   EOT

  service_account {
        email  = var.service_account_email
        scopes = ["cloud-platform"]
    }

}