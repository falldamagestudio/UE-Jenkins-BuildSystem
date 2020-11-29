project_id = "kalms-ue4-jenkins-buildsystem"
region     = "europe-west1"
zone       = "europe-west1-b"

build_artifacts_location = "europe-west1"

image          = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
boot_disk_type = "pd-balanced"
boot_disk_size = "10"
machine_type   = "n1-standard-1"
instance_name  = "jenkins-master"
ssh_username = "ansible"
ssh_pub_key_path = "jenkins-master-ansible.pub"
