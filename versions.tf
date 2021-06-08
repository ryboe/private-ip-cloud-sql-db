terraform {
  required_version = ">= 1.0.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.25.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 3.70.0"
    }
  }
}
