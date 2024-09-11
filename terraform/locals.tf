locals {
  docker_image_full_url = "gcr.io/${var.project_id}/${var.docker_image_name}:${var.docker_image_version}"
}
