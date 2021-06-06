output "public_ip" {
  description = "The public IP of the bastion instance running Cloud SQL Proxy"
  value       = google_compute_instance.db_proxy.network_interface.0.access_config.0.nat_ip
}
