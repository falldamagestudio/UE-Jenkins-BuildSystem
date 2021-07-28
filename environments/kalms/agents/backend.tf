terraform {
  backend "gcs" {
    prefix = "agents"
  }
}
