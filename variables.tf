variable "db_password" {
  description = "The Postgres password"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "The Postgres username"
  type = string
}

variable "gcp_project_name" {
  description = "The name of the GCP project where the db and Cloud SQL Proxy will be created"
  type = string
}

variable "gcp_region" {
  description = "The GCP region where the db and Cloud SQL Proxy will be created"
  type = string
}

variable "gcp_zone" {
  description = "The GCP availability zone where the db and Cloud SQL Proxy will be created"
  type = string
}
