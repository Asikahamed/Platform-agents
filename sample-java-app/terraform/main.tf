resource "google_cloud_run_v2_service" "app" {

  name     = var.service_name
  location = var.region

  template {

    containers {

      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repository}/${var.service_name}:${var.image_tag}"

      ports {
        container_port = 8080
      }

      resources {

        limits = {
          cpu    = "1"
          memory = "512Mi"
        }

      }

    }

  }

}

resource "google_cloud_run_service_iam_member" "public" {

  location = google_cloud_run_v2_service.app.location
  service  = google_cloud_run_v2_service.app.name

  role   = "roles/run.invoker"
  member = "allUsers"

}