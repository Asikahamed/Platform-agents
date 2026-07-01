############################################################
# Cloud Run Service
############################################################

resource "google_cloud_run_v2_service" "app" {

  name     = var.service_name
  location = var.region

  template {

    containers {

      # Placeholder image.
      # CD pipeline replaces this with the real application image.

      image = "us-docker.pkg.dev/cloudrun/container/hello"

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

############################################################
# Public Access
############################################################

resource "google_cloud_run_service_iam_member" "public" {

  location = google_cloud_run_v2_service.app.location

  service = google_cloud_run_v2_service.app.name

  role = "roles/run.invoker"

  member = "allUsers"

}
