output "proxy_ip" {
  description = <<-EOT
    The public IP of the instance running Cloud SQL Proxy. psql into this
    instance to connect to your private db.
    EOT
  value = module.dbproxy.public_ip
}
