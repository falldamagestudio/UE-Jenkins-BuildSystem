terraform {
  backend "gcs" {
    bucket = "fd-ue-jenkins-buildsystem-state"
    prefix = "core"
  }
}
