# ------------- dns.tf ------------------
# This file contains Google Cloud Platform resources as:
# - Cloud DNS Private Zone
# -------------------------------

module "cloud-dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "6.1.0"
  project_id = var.project_id
  type       = "private"
  name       = var.dns_zone_name
  domain     = var.dns_domain

  private_visibility_config_networks = [
    module.vpc.network_self_link
  ]
  
  depends_on = [module.vpc]
}