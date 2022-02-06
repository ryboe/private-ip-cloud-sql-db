// serviceaccount module
data "google_project" "provider" {}

resource "google_service_account" "account" {
  account_id  = var.name
  description = "The service account used by Cloud SQL Proxy to connect to the db"
}

resource "google_project_iam_member" "role" {
  project = data.google_project.provider.project_id
  role    = var.role
  member  = "serviceAccount:${google_service_account.account.email}"
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.account.name
}
