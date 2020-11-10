terraform_state_bucket = "fd-jenkins-cloud-state"

project_id = "fd-jenkins-cloud"
zone       = "europe-west1-b"

image          = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
boot_disk_type = "pd-balanced"
boot_disk_size = "10"
machine_type   = "n1-standard-1"
instance_name  = "jenkins-master"
ssh_username = "ansible"
ssh_pub_key_path = "jenkins-master-ansible.pub"
