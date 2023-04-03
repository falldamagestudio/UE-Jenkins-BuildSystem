
locals {

    ssh_agent_secrets_unfiltered = {
        ssh-vm-public-key-windows = {
          version = var.ssh_agent_settings.ssh-vm-public-key-windows
        }
    }

    ssh_agent_secrets = {
      for k, v in local.ssh_agent_secrets_unfiltered : k => v
      if v.version != ""
    }
}

resource "google_secret_manager_secret" "ssh_agent_secret" {

  for_each = local.ssh_agent_secrets

  secret_id = each.key

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "ssh_agent_secret_version" {

  for_each = local.ssh_agent_secrets

  secret = google_secret_manager_secret.ssh_agent_secret[each.key].id

  secret_data = each.value.version
}