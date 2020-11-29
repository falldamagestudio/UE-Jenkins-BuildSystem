terraform {

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.6"
    }

    external = {
      source  = "hashicorp/external"
      version = "~> 2.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.10, != 1.11.0"
    }
  }
}

provider "google" {

  project = var.project_id
  zone    = var.zone
}

provider "google-beta" {

  project = var.project_id
  zone    = var.zone
}

provider "time" {
}

provider "external" {
}

provider "null" {
}

provider "random" {
}

/******************************************
  Retrieve authentication token
 *****************************************/
data "google_client_config" "default" {
  provider = google-beta
}

/******************************************
  Configure provider
 *****************************************/

provider "kubernetes" {
  load_config_file       = false
//  host                   = "https://${local.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
//  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
}