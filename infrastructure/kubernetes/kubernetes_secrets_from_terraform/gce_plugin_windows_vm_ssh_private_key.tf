# Make private key that is used for logging in to Jenkins via SSH on Windows instances available to Jenkins
# This will be picked up by the Kubernetes Credentials Provider plugin
#  and be visible in the Credentials manager in Jenkins
#
# Reference: https://jenkinsci.github.io/kubernetes-credentials-provider-plugin/examples/

resource "kubernetes_secret" "gce_plugin_windows_vm_ssh_private_key" {

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
    privateKey = var.ssh_vm_private_key_windows
  }
}
