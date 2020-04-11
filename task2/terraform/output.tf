output "endpoint" {
  value = google_container_cluster.default.endpoint
}

output "version" {
  value = google_container_cluster.default.master_version
}

output "nat_ip" {
  value = google_compute_instance.default.network_interface.access_config.assigned_nat_ip
}

output "domain_name" {
  value = google_compute_instance.default.network_interface.access_config.public_ptr_domain_name
}