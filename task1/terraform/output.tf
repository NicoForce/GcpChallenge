output "endpoint" {
  value = google_container_cluster.default.endpoint
}

output "version" {
  value = google_container_cluster.default.master_version
}

output "auth" {
  value = google_container_cluster.default.master_auth
}