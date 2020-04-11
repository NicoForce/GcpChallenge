variable "name" {
  default = "task2-cluster"
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

variable "gce_ssh_user" {
  default = "admin"
}

variable "gce_ssh_pub_key_file" {
  default = "../id_rsa.pub"
}