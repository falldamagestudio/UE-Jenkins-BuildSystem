resource "kubernetes_secret" "jenkins-controller-from-terraform" {

  depends_on = [ module.kubernetes_cluster.endpoint ]

  metadata {
    name = "jenkins-controller-from-terraform"
  }

  data = {
    project = var.project_id
    region = var.region
    ingress_static_ip_address_name = var.external_ip_address_name
  }

  type = "Opaque"
}
