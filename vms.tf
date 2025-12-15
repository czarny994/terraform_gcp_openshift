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
  source                    = "./modules/vm"
  instance_name             = "bastion"
  machine_type              = "e2-medium"
  zone                      = "europe-central2-a"
  image                     = "projects/fedora-coreos-cloud/global/images/fedora-coreos-43-20251024-3-0-gcp-x86-64"
  disk_size                 = 100
  network_name              = module.vpc.network_self_link
  subnetwork_name           = module.vpc.subnets_self_links[0]
  roles                     = ["bastion", "ssh-allow"]
  service_account_email     = google_service_account.sa.email
  allow_stopping_for_update = true
  user                      = "ocp"
  ssh_public_key            = tls_private_key.ssh_key.public_key_openssh
  ignition_config           = local.ignition_config
  ocp_password              = var.ocp_password
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