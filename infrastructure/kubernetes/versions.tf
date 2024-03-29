terraform {
  required_providers {
    external = {
      source = "hashicorp/external"
      version = "~> 2.0.0"
    }

    google = {
      source = "hashicorp/google"
      version = "~> 3.77.0"
    }

    http = {
      source = "hashicorp/http"
      version = "~> 2.1.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.3.0"
    }

    null = {
      source = "hashicorp/null"
      version = "~> 3.0.0"
    }

    random = {
      source = "hashicorp/random"
      version = "~> 3.0.0"
    }

    time = {
      source = "hashicorp/time"
      version = "~> 0.7.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "~> 3.1.0"
    }
  }

  required_version = ">= 0.13"
}

provider "google" {
  project = var.project_id
  zone    = var.zone
}

data "google_client_config" "default" {
  provider = google
}

provider "kubernetes" {
  host                   = "https://${module.kubernetes_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.kubernetes_cluster.ca_certificate)
}