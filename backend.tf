terraform {
  backend "remote" {
    organization = "studybeast-org"
    workspaces {
      name = "private-ip-cloud-sql-db"
    }
  }
}
