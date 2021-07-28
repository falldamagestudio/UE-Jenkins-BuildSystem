data "terraform_remote_state" "core" {
  backend = "gcs"
  config = {
    bucket = "kalms-ue-jenkins-buildsystem-state"
    prefix = "core"
  }
}
