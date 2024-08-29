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
