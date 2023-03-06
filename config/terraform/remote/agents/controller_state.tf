data "terraform_remote_state" "controller" {
  backend = "gcs"
  config = {
    bucket = "fd-ue-jenkins-buildsystem-state"
    prefix = "controller"
  }
}
