# resource "google_storage_bucket" "gcp-test-bucket" {
#   name     = "bater-wucket"
#   location = "europe-central2"
#   force_destroy = true
# }
# 
# resource "google_storage_bucket_iam_binding" "public_access" {
#   bucket  = google_storage_bucket.gcp-test-bucket.name
#   role    = "roles/storage.objectViewer"
#   members = ["allUsers"]
# }
# 
# resource "google_storage_bucket" "gcp-test-bucket2" {
#   name     = "bava-lucket"
#   location = "europe-central2"
#   force_destroy = true
# }
# 
# resource "google_storage_bucket" "gcp-test-bucket3" {
#   name     = "bava-lucket-beta"
#   location = "europe-central2"
#   force_destroy = true
# }
# 
