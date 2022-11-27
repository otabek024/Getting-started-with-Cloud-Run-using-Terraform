terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.44.1"
    }
  }
}

provider "google" {
  project     = "project id"
  region      = "us-central1"
  zone        = "us-central1-a"
  credentials = "your json file from service account"
}