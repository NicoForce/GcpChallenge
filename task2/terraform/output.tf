output "endpoint" {
  value = google_container_cluster.default.endpoint
}

output "version" {
  value = google_container_cluster.default.master_version
}

output "nat_ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}