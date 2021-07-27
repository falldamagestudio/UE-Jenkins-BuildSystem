terraform {
  backend "gcs" {
    prefix = "kubernetes"
  }
}
