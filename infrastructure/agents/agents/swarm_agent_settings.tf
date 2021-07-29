
locals {

    swarm_agent_secrets = {
        jenkins-url = {
          version = var.swarm_agent_settings.jenkins-url
        }

        swarm-agent-image-url-linux = {
          version = var.swarm_agent_settings.swarm-agent-image-url-linux
        }

        swarm-agent-image-url-windows = {
          version = var.swarm_agent_settings.swarm-agent-image-url-windows
        }
    }
}

resource "google_secret_manager_secret" "swarm_agent_secret" {

  for_each = local.swarm_agent_secrets

  secret_id = each.key

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_member" "swarm_agent_secret_agent_access" {

  for_each = local.swarm_agent_secrets

  secret_id = google_secret_manager_secret.swarm_agent_secret[each.key].secret_id
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

resource "google_secret_manager_secret_version" "swarm_agent_secret_version" {

  for_each = local.swarm_agent_secrets

  secret = google_secret_manager_secret.swarm_agent_secret[each.key].id

  secret_data = each.value.version
}