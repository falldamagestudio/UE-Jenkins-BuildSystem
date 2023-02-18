project_id = "fd-ue-jenkins-buildsystem"
region     = "europe-west1"
zone       = "europe-west1-b"

build_artifacts_location = "europe-west1"

external_ip_address_name = "jenkins-controller-external-ip-address"
internal_ip_address_name = "jenkins-controller-internal-ip-address"
internal_ip_address = "10.142.15.250"

longtail_store_bucket_name = "fd-ue-jenkins-buildsystem-longtail"
longtail_store_location = "europe-west1"

image_builder_subnetwork_cidr_range = "10.148.0.0/20"
controller_vm_subnetwork_cidr_range = "10.142.0.0/24"
agent_vms_subnetwork_cidr_range = "10.143.0.0/20"
