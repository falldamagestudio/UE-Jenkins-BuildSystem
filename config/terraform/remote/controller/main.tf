module "controller" {

    source = "../../../../infrastructure/controller"

    project_id = data.terraform_remote_state.core.outputs.project_id
    region = data.terraform_remote_state.core.outputs.region
    zone = data.terraform_remote_state.core.outputs.zone

    controller_vm_network = data.terraform_remote_state.core.outputs.controller_vm_network
    controller_vm_subnetwork = data.terraform_remote_state.core.outputs.controller_vm_subnetwork

    longtail_store_bucket_name = data.terraform_remote_state.core.outputs.longtail_store_bucket_name

    ssh_vm_private_key_windows = data.terraform_remote_state.core.outputs.ssh_vm_private_key_windows

    controller_web_endpoint_domain = var.controller_web_endpoint_domain

    oauth2_client_id = var.oauth2_client_id

    machine_type = var.machine_type

    boot_disk_type = var.boot_disk_type
    boot_disk_size_gb = var.boot_disk_size_gb

    state_disk_type = var.state_disk_type
    state_disk_size_gb = var.state_disk_size_gb

    vm_image_name = var.vm_image_name
}
