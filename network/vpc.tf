# ------------- vpc.tf ------------------
# This file contains Google Cloud Platform resources as:
# - VPC Network with Master and Worker subnets
# -----------------------------------------------
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 13.0"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  bgp_best_path_selection_mode = "STANDARD"

  subnets = [
    {
      subnet_name           = var.subnet_master
      subnet_ip             = var.subnet_master_ip_range
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = var.subnet_worker
      subnet_ip             = var.subnet_worker_ip_range
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = var.subnet_gitlab
      subnet_ip             = var.subnet_gitlab_ip_range
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    }
  ]
}