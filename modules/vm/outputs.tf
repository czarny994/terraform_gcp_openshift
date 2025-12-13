output "external_ip" {
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
  description = "External IP address of the VM"
}

output "instance_id" {
  value       = google_compute_instance.vm_instance.instance_id
  description = "Instance ID of the VM"
}

output "instance_name" {
  value       = google_compute_instance.vm_instance.name
  description = "Name of the VM instance"
}
