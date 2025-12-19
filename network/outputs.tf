# ------------- outputs.tf ------------------
# This file contains outputs from the network module
# that will be used by other Terraform configurations
# -----------------------------------------------

output "service_account_email" {
  description = "The email of the service account"
  value       = google_service_account.sa.email
}

output "subnet_master_self_link" {
  description = "The self-link of the master subnet"
  value       = module.vpc.subnets_self_links[0]
}

output "subnet_worker_self_link" {
  description = "The self-link of the worker subnet"
  value       = module.vpc.subnets_self_links[1]
}

output "subnet_gitlab_link" {
  description = "The self-link of the gitlab subnet"
  value       = module.vpc.subnets_self_links[2]
}

output "network_self_link" {
  description = "The self-link of the VPC network"
  value       = module.vpc.network_self_link
}
