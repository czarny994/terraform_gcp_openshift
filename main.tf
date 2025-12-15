# ------------- main.tf ------------------
# This file contains Google Cloud Platform resources as:
# - Service Account
# - IAM Role Binding
# ----------------------------------------

# google_service_account.sa:
resource "google_service_account" "sa" {
  account_id   = "sa-ocp"
  description  = null
  disabled     = false
  display_name = "sa-ocp"
  project      = var.project_id
}

# google_project_iam_member.sa_owner:
resource "google_project_iam_member" "sa_owner" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

