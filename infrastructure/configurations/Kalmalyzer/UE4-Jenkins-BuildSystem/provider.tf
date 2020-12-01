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
  version = "~> 1.10, != 1.11.0"

  load_config_file       = false
//  host                   = "https://${local.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
//  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
}