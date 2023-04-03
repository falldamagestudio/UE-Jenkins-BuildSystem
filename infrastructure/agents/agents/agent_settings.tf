
locals {

    secrets = {
        agent-key-file = {
          version = base64decode(google_service_account_key.agent_service_account_key.private_key)
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

resource "google_secret_manager_secret_version" "agent_secret_version" {

  for_each = local.secrets

  secret = google_secret_manager_secret.agent_secret[each.key].id

  secret_data = each.value.version
}