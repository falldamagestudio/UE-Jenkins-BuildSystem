terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 3.77.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.77.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 2.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.7.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
  }

  required_version = ">= 0.13"
}

provider "google" {
  project = var.project_id
  zone    = var.zone
}
