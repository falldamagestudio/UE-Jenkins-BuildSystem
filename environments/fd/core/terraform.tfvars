project_id = "fd-ue-jenkins-buildsystem"
project_number = "227513122420"
region     = "europe-west1"
zone       = "europe-west1-b"

build_artifacts_location = "europe-west1"

external_ip_address_name = "jenkins-controller-external-ip-address"
internal_ip_address_name = "jenkins-controller-internal-ip-address"
internal_ip_address = "10.142.15.250"

longtail_store_bucket_name = "fd-ue-jenkins-buildsystem-longtail"
longtail_store_location = "europe-west1"

image_builder_subnetwork_cidr_range = "10.148.0.0/20"
agent_vms_subnetwork_cidr_range = "10.143.0.0/20"

kubernetes_cluster_network_config = {
    vms_cidr_range = "10.142.0.0/20"
    pods_cidr_range = "10.44.0.0/14"
    services_cidr_range = "10.48.0.0/20"
    internal_lb_cidr_range = "10.144.0.0/24"
}
