terraform {
  backend "gcs" {
    bucket = "kalms-ue-jenkins-buildsystem-state"
    prefix = "core"
  }
}
