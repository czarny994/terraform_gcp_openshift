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

# -------- VPC Variables --------
variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = ""
}

variable "subnet_master" {
  description = "The name of the master subnetwork"
  type        = string
  default     = "master-subnetwork"
}

variable "subnet_master_ip_range" {
  description = "The IP range for the master subnetwork"
  type        = string
  default     = "10.1.10.0/24"

}

variable "subnet_worker" {
  description = "The name of the worker subnetwork"
  type        = string
  default     = "worker-subnetwork"
}

variable "subnet_worker_ip_range" {
  description = "The IP range for the worker subnetwork"
  type        = string
  default     = "10.0.20.0/24"
}

variable "router" {
  description = "Whether to create a Cloud Router"
  type        = string
  default     = ""
}

variable "nat_master" {
  description = "The name of the Cloud NAT"
  type        = string
  default     = "ocp-nat-master-gw"
}

variable "nat_worker" {
  description = "The name of the Cloud NAT"
  type        = string
  default     = "ocp-nat-worker-gw"
}

# -------- DNS Variables --------
variable "dns_zone_name" {
  description = "The name of the DNS zone"
  type        = string
  default     = "example-com"
}

variable "dns_domain" {
  description = "The DNS domain"
  type        = string
  default     = "example.com"
}

# -------- VM Variables --------
variable "ocp_password" {
  description = "Password for the 'ocp' user on VMs"
  type        = string
  sensitive   = true
} 