terraform {
  required_version = ">= 1.4.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.42.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.56.0"
    }
  }
}
