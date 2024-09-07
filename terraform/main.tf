provider "google" {
  project = "gcp-test-433911"
  region  = "europe-central2"
  zone    = "europe-central2-a"
}

terraform {
  backend "gcs" {
    bucket = "bater-wucket-terraform"
    prefix = "terraform/state"
  }
}

variable "services" {
  default = [
    "compute.googleapis.com",
    "storage.googleapis.com",
    "run.googleapis.com",
    "container.googleapis.com"
  ]
}

resource "google_project_service" "services" {
  for_each = toset(var.services)
  project  = var.project_id
  service  = each.key
}

provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

resource "google_container_cluster" "primary" {
  name     = "bava-lucket-k8s-cluster"
  location = "europe-central2"

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow traffic from any IP address

  target_tags = ["http-server"] # Optional: Apply the rule to instances with this tag

  description = "Allow HTTP traffic on port 80"
}
