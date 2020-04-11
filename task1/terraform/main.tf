provider "google" {
  credentials = file(var.credentials)
  project = var.project-id
  region  = var.location
  zone    = var.zone
}

resource "google_container_cluster" "default" {
  name        = var.name
  location    = var.location

  remove_default_node_pool = true
  initial_node_count = var.initial_node_count

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "default" {
  name       = "${var.name}-node-pool"
  location   = var.location
  cluster    = google_container_cluster.default.name
  node_count = var.initial_node_count

  node_config {
    preemptible  = false
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}