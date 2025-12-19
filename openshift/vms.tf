# ------------- vms.tf ------------------
# This file contains Google Cloud Platform resources as:
# - Virtual Machines

# Generate SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

# Create Ignition config for Fedora CoreOS (JSON format)
locals {
  ignition_config = jsonencode({
    ignition = {
      version = "3.3.0"
    }
    passwd = {
      users = [
        {
          name         = "ocp"
          groups       = ["wheel", "sudo", "docker"]
          passwordHash = "$6$rounds=4096$saltsalt$3.SvOl.eZHZ0xxxxxxxxx"
          sshAuthorizedKeys = [
            tls_private_key.ssh_key.public_key_openssh
          ]
        }
      ]
    }
    systemd = {
      units = [
        {
          name     = "install-python3.service"
          enabled  = true
          contents = <<-EOT
            [Unit]
            Description=Install Python3 via rpm-ostree
            ConditionPathExists=!/var/lib/python3-installed
            After=network-online.target
            Wants=network-online.target
            
            [Service]
            Type=oneshot
            RemainAfterExit=yes
            ExecStartPre=/usr/bin/logger -t install-python3 "Starting Python3 installation"
            ExecStartPre=/usr/bin/rpm-ostree install --idempotent python3
            ExecStartPre=/usr/bin/touch /var/lib/python3-installed
            ExecStartPre=/usr/bin/logger -t install-python3 "Python3 installed, rebooting"
            ExecStart=/usr/bin/systemctl reboot
            
            [Install]
            WantedBy=multi-user.target
          EOT
        }
      ]
    }
  })
}

# Save private key locally (optional)
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_openssh
  filename        = "${path.module}/ssh-key"
  file_permission = "0600"
}

module "bastion_vm" {
  source                    = "../modules/vm"
  project_id                = var.project_id
  instance_name             = "bastion"
  machine_type              = "e2-medium"
  zone                      = "europe-central2-a"
  image                     = "projects/fedora-coreos-cloud/global/images/fedora-coreos-43-20251024-3-0-gcp-x86-64"
  disk_size                 = 100
  network_name              = local.network_self_link
  subnetwork_name           = local.subnet_master_link
  roles                     = ["bastion", "ssh-allow"]
  service_account_email     = local.service_account_email
  allow_stopping_for_update = true
  user                      = "ocp"
  ssh_public_key            = tls_private_key.ssh_key.public_key_openssh
  ignition_config           = local.ignition_config
  password                  = var.password
  metadata_startup_script   = <<-EOT
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
}

# Output commands to check Python3 installation logs
output "bastion_log_commands" {
  value       = <<-EOT
    
    === Check Python3 installation logs ===
    
    # 1. Check systemd service status:
    ssh -i ./ssh-key ocp@${module.bastion_vm.external_ip} "sudo systemctl status install-python3.service"
    
    # 2. View installation logs:
    ssh -i ./ssh-key ocp@${module.bastion_vm.external_ip} "sudo journalctl -u install-python3.service"
    
    # 3. View all relevant logs:
    ssh -i ./ssh-key ocp@${module.bastion_vm.external_ip} "sudo journalctl -t install-python3"
    
    # 4. Check if Python3 is installed:
    ssh -i ./ssh-key ocp@${module.bastion_vm.external_ip} "python3 --version"
    
    # 5. View serial port logs:
    gcloud compute instances get-serial-port-output bastion --zone=europe-central2-a | grep -i python
  EOT
  description = "Commands to view Python3 installation logs"
}