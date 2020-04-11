variable "name" {
  default = "challenge-cluster"
}

variable "project" {
  default = "My First Project"
}

variable "location" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

variable "description" {
  default = ""
}

variable "initial_node_count" {
  default = 1
}

variable "project-id" {
  default = ""
}

variable "credentials" {
  default = "../admin-myproject.json"
}

variable "machine_type" {
  default = "n1-standard-1"
}