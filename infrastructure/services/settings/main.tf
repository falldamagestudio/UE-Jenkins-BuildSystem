resource "kubernetes_secret" "jenkins-controller-from-terraform" {

  depends_on = [ var.module_depends_on ]

  metadata {
    name = "jenkins-controller-from-terraform"
  }

  data = {
    project = var.project_id
    region = var.region
    external_ingress_static_ip_address_name = var.external_ip_address_name
    internal_ingress_static_ip_address_name = var.internal_ip_address_name
    image_registry_prefix = var.image_registry_prefix
    longtail_store_bucket_name = var.longtail_store_bucket_name
    ssh_vm_private_key_windows = var.ssh_vm_private_key_windows
  }

  type = "Opaque"
}
