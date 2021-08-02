module "kubernetes" {

    source = "../../../infrastructure/kubernetes"

    project_id = data.terraform_remote_state.core.outputs.project_id
    project_number = data.terraform_remote_state.core.outputs.project_number
    region = data.terraform_remote_state.core.outputs.region
    zone = data.terraform_remote_state.core.outputs.zone

    kubernetes_network = data.terraform_remote_state.core.outputs.kubernetes_network
    kubernetes_subnetwork = data.terraform_remote_state.core.outputs.kubernetes_subnetwork
    kubernetes_subnetwork_id = data.terraform_remote_state.core.outputs.kubernetes_subnetwork_id

    external_ip_address_name = data.terraform_remote_state.core.outputs.external_ip_address_name
    internal_ip_address_name = data.terraform_remote_state.core.outputs.internal_ip_address_name
    internal_ip_address = data.terraform_remote_state.core.outputs.internal_ip_address

    longtail_store_bucket_name = data.terraform_remote_state.core.outputs.longtail_store_bucket_name

    allowed_login_domain = var.allowed_login_domain

    node_pools = var.node_pools

    ssh_vm_private_key_windows = data.terraform_remote_state.core.outputs.ssh_vm_private_key_windows
}
