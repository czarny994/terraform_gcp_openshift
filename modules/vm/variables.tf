variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "instance_name" {
    type = string
    description = "Name of VM"
    default = "vm-instance"
}

variable "machine_type" {
    default = "e2-medium"
  
}

variable "zone" {
    default = "europe-central2-a"
}

variable "image" {
    default = "projects/fedora-coreos-cloud/global/images/fedora-coreos-43-20251024-3-0-gcp-x86-64"
}

variable "service_account_email" {
  type        = string
  description = "Email of the service account to attach to VM"
}

variable "roles" {
  type        = list(string)
  description = "Roles to assign to the VM"
  default     = ["default-role"]
}

variable "disk_size" {
  type        = number
  description = "Size of the boot disk in GB"
  default     = 100
}

variable "allow_stopping_for_update" {
  type        = bool
  description = "Whether to allow stopping the instance for updates"
  default     = true
}

variable "network_name" {
  type        = string
  description = "Name of the network to attach the VM to"
  default     = "default"
}

variable "subnetwork_name" {
  type        = string
  description = "Name of the subnetwork to attach the VM to"
  default     = "default"
}


variable "user" {
  type        = string
  description = "Name of the user for SSH access"
  default     = ""
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the user"
  default     = ""
}
variable "startup_script" {
  type        = string
  description = "Path to the startup script to run on VM boot"
  default     = "startup.sh"
}

variable "ignition_config" {
  type        = string
  description = "Ignition config for Fedora CoreOS"
  default     = ""
}
variable "password" {
  type        = string
  description = "Password for the user"
}

variable "metadata_startup_script" {
  type        = string
  description = "Startup script to run on VM boot"
  default     = ""
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