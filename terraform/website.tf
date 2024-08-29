resource "google_storage_bucket" "gcp-test-html" {
  name          = "bava-website"
  location      = "europe-central2"
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_iam_binding" "gcp-test-html-iam" {
  bucket  = google_storage_bucket.gcp-test-html.name
  role    = "roles/storage.objectViewer"
  members = ["allUsers"]
}

resource "google_storage_bucket_object" "index-html" {
  name   = "index.html"
  bucket = google_storage_bucket.gcp-test-html.name
  source = "../index.html"
}

resource "random_pet" "rand_name" {
}

output "rand_name" {
  value = random_pet.rand_name
}
