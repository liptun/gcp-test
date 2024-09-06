resource "google_cloud_run_service" "gcp_test_docker" {
  name     = "bater-wucket-service"
  location = "europe-central2"

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/gcp-test-docker:1.1"
        ports {
          container_port = 3000
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {
  member   = "allUsers"
  service  = google_cloud_run_service.gcp_test_docker.name
  location = google_cloud_run_service.gcp_test_docker.location
  role     = "roles/run.invoker"

}

output "url" {
  value = google_cloud_run_service.gcp_test_docker.status[0].url
}
