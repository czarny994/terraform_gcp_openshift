# ------------- outputs.tf ------------------
# This file contains outputs from the network module
# that will be used by other Terraform configurations
# -----------------------------------------------

output "service_account_email" {
  description = "The email of the service account"
  value       = google_service_account.sa.email
}
