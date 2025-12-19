# -------- General Variables --------
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "europe-central2-a"
}

variable "disk_size_gb" {
  description = "The size of the disk in GB"
  type        = string
  default     = "50"
}
variable "attached_disk_source" {
  type        = string
  description = "Source of the attached disk"
  default     = ""
}
variable "attached_disk_device_name" {
  type        = string
  description = "Device name of the attached disk"
  default     = ""
}