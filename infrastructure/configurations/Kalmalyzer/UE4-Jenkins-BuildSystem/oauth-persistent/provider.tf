provider "google" {

  version = "~> 3.0"

  project = var.project_id
  zone    = var.zone
}

provider "time" {
  version = "~> 0.6.0"
}