provider "google" {
  version = "~> 3.0"

  project = var.project_id
  zone    = var.zone
}

provider "google-beta" {
  version = "~> 3.0"

  project = var.project_id
  zone    = var.zone
}

provider "time" {
  version = "~> 0.6"
}

provider "external" {
  version = "~> 2.0.0"
}

provider "null" {
  version = "~> 3.0.0"
}

provider "random" {
  version = "~> 3.0.0"
}

provider "http" {
  version = "~> 2.1"
}