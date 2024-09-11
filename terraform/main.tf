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
    "container.googleapis.com",
  ]
}

resource "google_project_service" "services" {
  for_each = toset(var.services)
  project  = var.project_id
  service  = each.key
}
