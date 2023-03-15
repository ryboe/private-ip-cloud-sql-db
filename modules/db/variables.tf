// db module

variable "db_depends_on" {
  description = "Resources that the database instance depends on"
  type        = list(any)
}

variable "disk_size" {
  description = "The size in GB of the disk used by the db"
  type        = number
}

variable "instance_type" {
  description = "The instance type of the VM that will run the db (e.g. db-f1-micro, db-custom-8-32768)"
  type        = string
}

variable "password" {
  description = "The db password used to connect to the Postgers db"
  type        = string
  sensitive   = true
}

variable "user" {
  description = "The username of the db user"
  type        = string
}

variable "vpc_link" {
  description = "A link to the VPC where the db will live (i.e. google_compute_network.some_vpc.self_link)"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC where the db will live"
  type        = string
}
