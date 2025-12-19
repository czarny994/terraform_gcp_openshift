resource "google_compute_disk" "gitlab_data_disk" {
  project = var.project_id
  name = "gitlab-data-disk"
  type = "pd-standard"
  zone = var.region
  size = var.disk_size_gb
}

module "bastion_vm" {
  source                    = "../modules/vm"
  project_id                = var.project_id
  instance_name             = "gitlab"
  machine_type              = "e2-medium"
  zone                      = "europe-central2-a"
  image                     = "projects/fedora-coreos-cloud/global/images/fedora-coreos-43-20251024-3-0-gcp-x86-64"
  disk_size                 = 100
  attached_disk_source      = google_compute_disk.gitlab_data_disk.id
  attached_disk_device_name = google_compute_disk.gitlab_data_disk.name
  network_name              = local.network_self_link
  subnetwork_name           = local.subnet_gitlab_link
  roles                     = ["gitlab", "ssh-allow"]
  service_account_email     = local.service_account_email
  allow_stopping_for_update = true
  user                      = "ocp"
  ssh_public_key            = ""
  ignition_config           = ""
  password                  = "changeme"
  metadata_startup_script   = <<-EOT
    #!/bin/bash
    set -euxo pipefail
    
    echo "=== Welcome on GitLab VM ==="
   EOT
}