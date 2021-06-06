provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region
  zone    = var.gcp_zone
}
