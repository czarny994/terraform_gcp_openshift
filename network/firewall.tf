# ------------- firewall.tf ------------------
# This file contains Google Cloud Platform resources as:
# - VPC Firewall Policy
# Rules:
#   - Allow internal traffic between master and worker subnets
#   - Allow SSH (22) from internet
#   - Allow HTTPS (443) from internet
#   - Allow RDP (3389) from internet
# -----------------------------------------------

module "network_firewall_policy" {
  source      = "terraform-google-modules/network/google//modules/network-firewall-policy"
  version     = "~> 13.0"
  project_id  = var.project_id
  policy_name = "my-firewall-policy"
  description = "Test firewall policy"
  target_vpcs = ["projects/${var.project_id}/global/networks/${var.network_name}"]

  depends_on = [module.vpc]

  rules = [
    {
      priority       = "1"
      direction      = "INGRESS"
      action         = "allow"
      rule_name      = "ocp-network-allow-internal"
      description    = "Allow internal traffic between master and worker subnets"
      enable_logging = true
      match = {
        src_ip_ranges = [var.subnet_worker_ip_range, var.subnet_master_ip_range]
        layer4_configs = [
          {
            ip_protocol = "all"
          },
        ]
      }
    },
    {
      priority       = "100"
      direction      = "INGRESS"
      action         = "allow"
      rule_name      = "ocp-network-allow-external-ssh"
      description    = "Allow SSH from internet"
      enable_logging = true
      match = {
        src_ip_ranges = ["0.0.0.0/0"]
        layer4_configs = [
          {
            ip_protocol = "tcp"
            ports       = ["22"]
          },
        ]
      }
    },
    {
      priority       = "101"
      direction      = "INGRESS"
      action         = "allow"
      rule_name      = "ocp-network-allow-external-https"
      description    = "Allow HTTPS from internet"
      enable_logging = true
      match = {
        src_ip_ranges = ["0.0.0.0/0"]
        layer4_configs = [
          {
            ip_protocol = "tcp"
            ports       = ["443"]
          },
        ]
      }
    },
    {
      priority       = "102"
      direction      = "INGRESS"
      action         = "allow"
      rule_name      = "ocp-network-allow-external-ports-3389"
      description    = "Allow RDP from internet"
      enable_logging = true
      match = {
        src_ip_ranges = ["0.0.0.0/0"]
        layer4_configs = [
          {
            ip_protocol = "tcp"
            ports       = ["3389"]
          },
        ]
      }
    }
  ]

}