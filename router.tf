# ------------- router.tf ------------------
# This file contains Google Cloud Platform resources as:
# - Cloud Router with Cloud NAT for Master and Worker subnets
# -----------------------------------------------


module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 8.0"

  name    = var.router
  region  = var.region

  project_id = var.project_id
  network = module.vpc.network_name
  
  depends_on = [module.vpc]

# This steps will create Cloud NAT for Master and Worker subnets
  nats = [
    {
      name                             = var.nat_master
      nat_ip_allocate_option           = "AUTO_ONLY"
      source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
      subnetworks = [
        {
          name                     = var.subnet_master
          source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
          secondary_ip_range_names = []
        }
      ]
    },
    {
      name                             = var.nat_worker
      nat_ip_allocate_option           = "AUTO_ONLY"
      source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
      subnetworks = [
        {
          name                     = var.subnet_worker
          source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
          secondary_ip_range_names = []
        }
      ]
    }
  ]
}