# -------- General Variables --------
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "europe-central2"
}

# -------- VM Variables --------
variable "ocp_password" {
  description = "Password for the 'ocp' user on VMs"
  type        = string
  sensitive   = true
} 