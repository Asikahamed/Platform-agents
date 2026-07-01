############################################################
# Enable Cloud Run API
############################################################

resource "google_project_service" "cloudrun" {

  project = var.project_id
  service = "run.googleapis.com"

  disable_on_destroy = false

}

############################################################
# Enable IAM API
############################################################

resource "google_project_service" "iam" {

  project = var.project_id
  service = "iam.googleapis.com"

  disable_on_destroy = false

}

############################################################
# Cloud Run Service
############################################################

resource "google_cloud_run_v2_service" "app" {

  depends_on = [
    google_project_service.cloudrun,
    google_project_service.iam
  ]

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
