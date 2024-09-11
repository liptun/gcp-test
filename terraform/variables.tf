variable "project_id" {
  description = "GCP project id"
  type        = string
}

variable "docker_image_name" {
  description = "GCR image name"
  type        = string
}

variable "docker_image_version" {
  description = "GCR image version"
  type        = string
}

variable "docker_image_full_url" {
  type        = string
  description = "Full Docker image URL"
  default     = "gcr.io/${var.project_id}/${var.docker_image_name}:${var.docker_image_version}"
}
