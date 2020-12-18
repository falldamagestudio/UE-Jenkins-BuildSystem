resource "kubernetes_secret" "jenkins-controller-from-terraform" {

  depends_on = [ var.module_depends_on ]

  metadata {
    name = "jenkins-controller-from-terraform"
  }

  data = {
    project = var.project_id
    region = var.region
    ingress_static_ip_address_name = var.external_ip_address_name
    controller_image = var.controller_image
  }

  type = "Opaque"
}
