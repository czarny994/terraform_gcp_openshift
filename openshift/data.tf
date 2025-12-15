# ------------- data.tf ------------------
# This file imports outputs from the network Terraform state
# -----------------------------------------------

data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../network/terraform.tfstate"
  }
}

# Create local variables for easier access
locals {
  network_self_link     = data.terraform_remote_state.network.outputs.network_self_link
  subnet_master_link    = data.terraform_remote_state.network.outputs.subnet_master_self_link
  subnet_worker_link    = data.terraform_remote_state.network.outputs.subnet_worker_self_link
  service_account_email = data.terraform_remote_state.network.outputs.service_account_email
}
