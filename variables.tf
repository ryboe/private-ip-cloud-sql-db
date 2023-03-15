variable "db_password" {
  description = "The Postgres password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) > 16
    error_message = "The db_password must be at least 16 characters long."
  }
}

variable "db_username" {
  description = "The Postgres username"
  type        = string

  validation {
    condition     = length(var.db_username) > 0
    error_message = "The db_username must be at least 1 character long."
  }
}

variable "gcp_project_name" {
  description = "The name of the GCP project where the db and Cloud SQL Proxy will be created"
  type        = string
}

variable "gcp_region" {
  description = "The GCP region where the db and Cloud SQL Proxy will be created"
  type        = string

  validation {
    condition = contains([
      "asia-east1",
      "asia-east2",
      "asia-northeast1",
      "asia-northeast2",
      "asia-northeast3",
      "asia-south1",
      "asia-south2",
      "asia-southeast1",
      "asia-southeast2",
      "australia-southeast1",
      "australia-southeast2",
      "europe-central2",
      "europe-north1",
      "europe-southwest1",
      "europe-west1",
      "europe-west2",
      "europe-west3",
      "europe-west4",
      "europe-west6",
      "europe-west8",
      "europe-west9",
      "me-west1",
      "northamerica-northeast1",
      "northamerica-northeast2",
      "southamerica-east1",
      "southamerica-west1",
      "us-central1",
      "us-east1",
      "us-east4",
      "us-east5",
      "us-south1",
      "us-west1",
      "us-west2",
      "us-west3",
      "us-west4",
    ], var.gcp_region)
    error_message = "Your gcp_region is not on our list of supported regions."
  }
}

variable "gcp_zone" {
  description = "The GCP availability zone where the db and Cloud SQL Proxy will be created"
  type        = string
}
