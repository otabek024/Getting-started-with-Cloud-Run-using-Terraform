resource "google_cloud_run_service" "cloud-run-tf" {
  name     = "cloud-run-tf"
  location = "us-central1"

  template {
    spec {
      containers {
        #image = "gcr.io/google-samples/hello-app:1.0"
        image = "gcr.io/google-samples/hello-app:2.0"
      }
    }
  }

  traffic {
    revision_name = "cloud-run-tf-qtljv"
    percent         = 50
  }
  traffic {
    revision_name = "cloud-run-tf-pn56q"
    percent         = 50
  }
}

resource "google_cloud_run_service_iam_policy" "pub1-access" {
  service = google_cloud_run_service.cloud-run-tf.name
  location = google_cloud_run_service.cloud-run-tf.location
  policy_data = data.google_iam_policy.pub-1.policy_data
}

data "google_iam_policy" "pub-1" {
  binding {
    role = "roles/run.invoker"
    members = ["allUsers"]
  }
}