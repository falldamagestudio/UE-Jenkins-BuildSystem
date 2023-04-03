locals {

  windows-vm-ssh = {

    gce-plugin-windows-vm-ssh-private-key = {
      version = var.ssh_vm_private_key_windows
    }
  }
}

resource "google_secret_manager_secret" "controller_gce_plugin_windows_vm_ssh_private_key_secret" {

  for_each = local.windows-vm-ssh

  secret_id = each.key

  labels = {
    # This is a SSH User Private Key type credential, accessible to Jenkins via the GCP Secrets Manager Credentials Provider plugin
    jenkins-credentials-type = "ssh-user-private-key"
    jenkins-credentials-username = "jenkins"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "controller_gce_plugin_windows_vm_ssh_private_key_secret_version" {

  for_each = local.windows-vm-ssh

  secret = google_secret_manager_secret.controller_gce_plugin_windows_vm_ssh_private_key_secret[each.key].id

  secret_data = each.value.version
}
