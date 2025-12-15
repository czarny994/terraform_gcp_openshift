# ------------- provider.tf ------------------
# This file contains Google Cloud Platform provider configuration
# -----------------------------------------------

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = var.project_id
  region  = "europe-central2-a"
}

