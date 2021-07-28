
locals {

    secrets = {
        ssh-agent-image-url-linux = {
          version = var.settings.ssh-agent-image-url-linux
        }

        ssh-agent-image-url-windows = {
          version = var.settings.ssh-agent-image-url-windows
        }

        ssh-vm-public-key-windows = {
          version = var.settings.ssh-vm-public-key-windows
        }
    }
}

resource "google_secret_manager_secret" "agent_secret" {

  for_each = local.secrets

  secret_id = each.key

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_member" "agent_secret_agent_access" {

  for_each = local.secrets

  secret_id = google_secret_manager_secret.agent_secret[each.key].secret_id
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${var.agent_service_account_email}"
}

resource "google_secret_manager_secret_version" "agent_secret_version" {

  for_each = local.secrets

  secret = google_secret_manager_secret.agent_secret[each.key].id

  secret_data = each.value.version
}