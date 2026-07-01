output "service_name" {

  description = "Cloud Run Service Name"

  value = google_cloud_run_v2_service.app.name

}

output "service_url" {

  description = "Cloud Run URL"

  value = google_cloud_run_v2_service.app.uri

}
