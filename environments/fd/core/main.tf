module "core" {

    source = "../../../infrastructure/core"

    project_id = var.project_id
    project_number = var.project_number
    region = var.region
    zone = var.zone

    build_artifacts_location = var.build_artifacts_location

    external_ip_address_name = var.external_ip_address_name
    internal_ip_address_name = var.internal_ip_address_name
    internal_ip_address = var.internal_ip_address

    longtail_store_bucket_name = var.longtail_store_bucket_name
    longtail_store_location = var.longtail_store_location

    image_builder_subnetwork_cidr_range = var.image_builder_subnetwork_cidr_range
    controller_vm_subnetwork_cidr_range = var.controller_vm_subnetwork_cidr_range
    agent_vms_subnetwork_cidr_range = var.agent_vms_subnetwork_cidr_range
}
