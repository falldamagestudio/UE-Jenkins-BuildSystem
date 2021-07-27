
locals {

    secrets = {
        jenkins-url = {
          version = var.settings.jenkins-url
        }

        agent-key-file = {
          version = base64decode(google_service_account_key.agent_service_account_key.private_key)
        }

        ssh-agent-image-url-linux = {
          version = var.settings.ssh-agent-image-url-linux
        }

        ssh-agent-image-url-windows = {
          version = var.settings.ssh-agent-image-url-windows
        }

        swarm-agent-image-url-linux = {
          version = var.settings.swarm-agent-image-url-linux
        }

        swarm-agent-image-url-windows = {
          version = var.settings.swarm-agent-image-url-windows
        }

        ssh-vm-public-key-windows = {
          version = var.settings.ssh-vm-public-key-windows
        }
    }
}

resource "google_secret_manager_secret" "agent_secret" {

  depends_on = [ var.module_depends_on ]

  for_each = local.secrets

  secret_id = each.key

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_member" "agent_secret_agent_access" {
  depends_on = [ var.module_depends_on ]

  for_each = local.secrets

  secret_id = google_secret_manager_secret.agent_secret[each.key].secret_id
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

resource "google_secret_manager_secret_version" "agent_secret_version" {
  depends_on = [ var.module_depends_on ]

  for_each = local.secrets

  secret = google_secret_manager_secret.agent_secret[each.key].id

  secret_data = each.value.version
}