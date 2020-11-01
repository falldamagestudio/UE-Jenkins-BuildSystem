terraform {
  backend "gcs" {
    prefix = "oauth-persistent"
  }
}
