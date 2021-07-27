project_id = "kalms-ue-jenkins-buildsystem"
project_number = "247607277820"
region     = "europe-west1"
zone       = "europe-west1-b"

build_artifacts_location = "europe-west1"

external_ip_address_name = "jenkins-controller-external-ip-address"
internal_ip_address_name = "jenkins-controller-internal-ip-address"
internal_ip_address = "10.132.15.250"

longtail_store_bucket_name = "kalms-ue-jenkins-buildsystem-longtail"
longtail_store_location = "europe-west1"

cloud_config_store_bucket_name = "kalms-ue-jenkins-buildsystem-cloud-config"
cloud_config_store_location = "europe-west1"

image_builder_subnetwork_cidr_range = "10.138.0.0/20"
agent_vms_subnetwork_cidr_range = "10.133.0.0/20"

kubernetes_cluster_network_config = {
    vms_cidr_range = "10.132.0.0/20"
    pods_cidr_range = "10.24.0.0/14"
    services_cidr_range = "10.28.0.0/20"
    internal_lb_cidr_range = "10.134.0.0/24"
}
