module "vpc" {
  source = "./modules/vpc"

  name = "main-vpc"
}

module "db" {
  source = "./modules/db"

  disk_size     = 10
  instance_type = "db-f1-micro"
  password      = var.db_password # This is a variable because it's a secret. It's stored here: https://app.terraform.io/app/<YOUR-ORGANIZATION>/workspaces/<WORKSPACE>/variables
  user          = var.db_username
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
  region           = var.gcp_region
  zone             = var.gcp_zone

  # By passing the VPC name as the output of the VPC module we ensure the VPC
  # will be created before the proxy.
  vpc_name = module.vpc.name
}
