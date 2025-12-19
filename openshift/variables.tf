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

variable "user" {
  description = "Username for the VM"
  type        = string
  default     = "ocp"
}

# -------- VM Variables --------
variable "password" {
  description = "Password for the user on VMs"
  type        = string
  sensitive   = true
} 