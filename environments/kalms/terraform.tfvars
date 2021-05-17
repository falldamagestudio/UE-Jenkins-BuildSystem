project_id = "kalms-ue4-jenkins-buildsystem"
project_number = "220788758027"
region     = "europe-west1"
zone       = "europe-west1-b"

build_artifacts_location = "europe-west1"

external_ip_address_name = "jenkins-controller-external-ip-address"
internal_ip_address_name = "jenkins-controller-internal-ip-address"

longtail_store_bucket_name = "kalms-ue4-jenkins-longtail"
longtail_store_location = "europe-west1"

cloud_config_store_bucket_name = "kalms-ue4-jenkins-cloud-config"
cloud_config_store_location = "europe-west1"

allowed_login_domain = "falldamagestudio.com"

linux_swarm_agent_image = "projects/cos-cloud/global/images/cos-89-16108-403-26"
linux_swarm_agent_cloud_config_url = "https://storage.googleapis.com/kalms-ue4-jenkins-cloud-config/ue-jenkins-swarm-agent-vm/cloud-config-commit-00b4ffb.yaml"
windows_swarm_agent_image = "projects/kalms-ue4-jenkins-buildsystem/global/images/ue-jenkins-swarm-agent-vm-00b4ffb-windows"