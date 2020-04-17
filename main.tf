// root module

terraform {
  required_version = "~> 0.12.24"
  required_providers {
    tfe         = "~> 0.16.0"
    google      = "~> 3.17.0"
    google-beta = "~> 3.17.0" # for enabling private services access
  }
  backend "remote" {
    organization = "my-terraform-cloud-org"
    workspaces {
      name = "private-ip-cloud-sql-db"
    }
  }
}

locals {
  db_username      = "my_user" # Postgres username
  gcp_project_name = "norse-baton-274601"
  gcp_region       = "us-central1"
  gcp_zone         = "us-central1-b"
}

provider "google" {
  project = local.gcp_project_name
  region  = local.gcp_region
  zone    = local.gcp_zone
}

provider "google-beta" {
  project = local.gcp_project_name
  region  = local.gcp_region
  zone    = local.gcp_zone
}

module "vpc" {
  # Override the default google provider with the google-beta provider. We need
  # the beta provider to enable setting a private IP for the db.
  providers = {
    google = google-beta
  }
  source = "./modules/vpc"

  name = "main-vpc"
}

module "db" {
  providers = {
    google = google-beta
  }

  source = "./modules/db"

  disk_size     = 10
  instance_type = "db-f1-micro"
  password      = var.db_password # This is a variable because it's a secret. It's stored here: https://app.terraform.io/app/<YOUR-ORGANIZATION>/workspaces/<WORKSPACE>/variables
  user          = local.db_username
  vpc_name      = module.vpc.name
  vpc_link      = module.vpc.link

  # There's a dependency relationship between the db and the VPC that
  # terraform can't figure out. The db instance depends on the VPC because it
  # uses a private IP from a block of IPs defined in the VPC. If we just giving
  # the db a public IP, there wouldn't be a dependency. The dependency exists
  # because we've configured private services access. We need to explicitly
  # specify the dependency here. For details, see the note in the docs here:
  #   https://www.terraform.io/docs/providers/google/r/sql_database_instance.html#private-ip-instance
  db_depends_on = module.vpc.private_vpc_connection
}

module "dbproxy" {
  source = "./modules/dbproxy"

  machine_type     = "f1-micro"
  db_instance_name = module.db.connection_name # e.g. my-project:us-central1:my-db
  region           = local.gcp_region
  zone             = local.gcp_zone

  # By passing the VPC name ("main-vpc") as the output of the VPC module
  # (module.vpc.name), we ensure the VPC will be created before the proxy.
  vpc_name = module.vpc.name
}
