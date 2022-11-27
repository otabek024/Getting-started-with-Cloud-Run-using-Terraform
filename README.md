# Getting Started with Cloud Run using Terraform

<p>In this small project, I will be guiding you working with Cloud Run using Terraform. I will try to explain each step. It will be very handful if you are learning GCP along with Terraform. This tiny project will also help you to understand Terraform basic commands as well as how to deploy Cloud Run service and service's revision.</p>

## Setting Up with VS Code

<p>I will be using Visual Studio Code for running my Terraform scripts. To start, I will create a folder and paste it inside my VS Code Editor and create following files inside it:</p>

* main.tf 
* provider.tf 
* Upload keys.json from service account 

## Use Google Provider

1. Get the [Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs). The Google provider is used to configure your Google Cloud Platform infrastructure. See the Getting Started page for an introduction to using the provider.

2. Copy and paste your project id
3. Give region and zone arguments
3. Finally, for credentials argument get [service account keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) from IAM & Admin
4. Your final provider.tf file should be like following:

```
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
```

## Start working with Main.tf file 

1. In order to create Cloud Run Service, start using [google_cloud_run_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) resource block from Terraform Registry page by specifying following required arguments.

* name
* location
* template 
* traffic

2. Inside your template you have containers section where you need to provide image. To get the image go to [Container Registry Image](https://console.cloud.google.com/gcr/images/google-samples/global/hello-app?tag=1.0) and copy version one first and run terraform apply after that comment it out and use version two to deploy second revision. 

3. In order to see Cloud Run Service URL you need to allow public access by using [google_cloud_run_service_iam_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam) resource block by specifying following arguments:

* service 
* location
* policy_data

4. For policy_data you need to use [google_iam_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) by specifying following arguments:  

* binding
  * role
  * member

5. Your final main.tf file should be like following:

```
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

```

# Run Terraform commands

```
terraform init
terraform fmt
terraform validate 
terraform plan 
terraform apply 
```

After you finish up do not forget to destroy 

```
terraform destroy
```

# Congratulations

For more content like this follow me on: 

* [Linkedin](https://www.linkedin.com/in/otabek-abdurakhmonov-46772b213/)
* [YouTube](https://www.youtube.com/channel/UCPPIjmkbaopLMucC2fMs4fg)
* [GitHub](https://github.com/otabek024)
