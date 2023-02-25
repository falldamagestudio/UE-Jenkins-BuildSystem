data "terraform_remote_state" "core" {
  backend = "gcs"
  config = {
    bucket = "fd-ue-jenkins-buildsystem-state"
    prefix = "core"
  }
}
