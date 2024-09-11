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
  }
}

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

# Kubernetes Deployment Resource
resource "kubernetes_deployment" "gcp_test_docker" {
  metadata {
    name      = "gcp-test-docker-deployment"
    namespace = "default"
    labels = {
      app = "gcp-test-docker"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "gcp-test-docker"
      }
    }
    template {
      metadata {
        labels = {
          app = "gcp-test-docker"
        }
      }
      spec {
        container {
          image = local.docker_image_full_url
          name  = "gcp-test-docker-container"
          port {
            container_port = 3000  # The container is still running on port 3000
          }
        }
      }
    }
  }
}

# Kubernetes Service Resource
resource "kubernetes_service" "gcp_test_docker_service" {
  metadata {
    name = "gcp-test-docker-service"  # Updated service name
  }
  spec {
    selector = {
      app = "gcp-test-docker"  # Matching the label of the deployment
    }
    port {
      port        = 80          # Expose the service on port 80
      target_port = 3000        # Forward traffic to container's port 3000
    }
    type = "NodePort"           # Keeping the type NodePort for external access
  }
}

# Kubernetes Ingress Resource
resource "kubernetes_ingress" "gcp_test_docker_ingress" {
  metadata {
    name = "gcp-test-docker-ingress"  # Updated ingress name
    annotations = {
      "kubernetes.io/ingress.class" = "gce"  # Using GCE as the ingress controller
    }
  }

  spec {
    backend {
      service_name = kubernetes_service.gcp_test_docker_service.metadata[0].name
      service_port = 80
    }
  }
}
