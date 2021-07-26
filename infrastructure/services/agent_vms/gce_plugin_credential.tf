# Create a service account, that the Google Compute Engine plugin subsequently can use
#  for controlling VMs
resource "google_service_account" "gce_plugin_service_account" {
  depends_on = [ var.module_depends_on ]

  account_id   = "gce-plugin-for-jenkins"
  display_name = "GCE Plugin for Jenkins"
}

// GCE plugin for Jenkins requires the account to to have the Compute Instance Admin (beta) role
resource "google_project_iam_member" "gce_plugin_compute_instance_admin" {
  depends_on = [ var.module_depends_on ]

  // Grant the Compute Instance Admin (beta) role
  // Reference: https://cloud.google.com/compute/docs/access/iam#compute.instanceAdmin
  role   = "roles/compute.instanceAdmin"
  member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
}

// GCE plugin for Jenkins requires the account to to have the Compute Network Admin role
resource "google_project_iam_member" "gce_plugin_compute_network_admin" {
  depends_on = [ var.module_depends_on ]

  // Grant the Compute Network Admin role
  // Reference: https://cloud.google.com/compute/docs/access/iam#compute.networkAdmin
  role   = "roles/compute.networkAdmin"
  member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
}

// GCE plugin for Jenkins requires the account to to have the Service Account User role
resource "google_project_iam_member" "gce_plugin_iam_service_account_user" {
  depends_on = [ var.module_depends_on ]

  // Grant the Service Account User role
  // Reference: https://cloud.google.com/compute/docs/access/iam#iam.serviceAccountUser
  role   = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
}

resource "google_service_account_key" "gce_plugin_service_account_key" {
  depends_on = [ var.module_depends_on ]

  service_account_id = google_service_account.gce_plugin_service_account.name
}

# TODO: First, make kubernetes credentials provider able to create GoogleRobotPrivateKeyCredentials
# and then make this write a secret of that type, with the private key & project ID attached
#
## Make service account key available to Jenkins
## This will be picked up by the Kubernetes Credentials Provider plugin
##  and be visible in the Credentials manager in Jenkins
##
## Reference: https://jenkinsci.github.io/kubernetes-credentials-provider-plugin/examples/
## Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key
#
#resource "kubernetes_secret" "gce_plugin_service_account_key" {
#  depends_on = [ var.module_depends_on ]
#
#  metadata {
#    # Credential name is the identifier used in the withCredentials() call
#    name = "gce-plugin-service-account"
#    labels = {
#      "jenkins.io/credentials-type" = "secretFile"
#    }
#    annotations = {
#      "jenkins.io/credentials-description" : "Service Account used by Google Compute Engine plugin in Jenkins to control VMs"
#    }
#  }
#
#  type = "Opaque"
#
#  data = {
#    # Private key file (JSON format) for a service account in GCP
#    "data" = base64decode(google_service_account_key.gce_plugin_service_account_key.private_key)
#
#    # File name is not used in practice, but required by Jenkins nevertheless
#    "filename" = "gce_plugin-service-account-key.json"
#  }
#}

# Make private key that is used for logging in to Jenkins via SSH on Windows instances available to Jenkins
# This will be picked up by the Kubernetes Credentials Provider plugin
#  and be visible in the Credentials manager in Jenkins
#
# Reference: https://jenkinsci.github.io/kubernetes-credentials-provider-plugin/examples/

resource "kubernetes_secret" "gce_plugin_windows_vm_ssh_private_key" {
  depends_on = [ var.module_depends_on ]

  metadata {
    # Credential name is the identifier used in the withCredentials() call
    name = "gce-plugin-windows-vm-ssh-private-key"
    labels = {
      "jenkins.io/credentials-type" = "basicSSHUserPrivateKey"
      "jenkins.io/credentials-scope" = "system"
    }
    annotations = {
      "jenkins.io/credentials-description" : "SSH account used by Google Compute Engine plugin in Jenkins to log in to Windows VMs and run Jenkins agents"
    }
  }

  type = "Opaque"

  data = {
    username = "jenkins"

    # Private key file (PEM format) for an SSH account
    privateKey = tls_private_key.ssh_vm_key.private_key_pem
  }
}
