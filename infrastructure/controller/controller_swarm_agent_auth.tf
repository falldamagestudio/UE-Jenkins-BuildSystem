resource "random_password" "swarm_agent_password" {
  length = 32
}

resource "random_id" "swarm_agent_api_token" {
  // Jenkins expects a version-11 API token to contain 32 hex digits
  byte_length = 16
}

locals {

  secrets = {

    swarm_agent_username = {
      version = "swarm_agent_user"
    }

    swarm_agent_password = {
      version = random_password.swarm_agent_password.result
    }

    swarm_agent_api_token_key = {
      version = "swarm_agent_api_token"
    }

    swarm_agent_api_token = {
      // Jenkins API tokens contain the version number, followed by the token itself
      //   and the current API token format is v11
      version = "11${random_id.swarm_agent_api_token.hex}"
    }
  }
}

resource "google_secret_manager_secret" "controller_swarm_agent_auth_secret" {

  for_each = local.secrets

  secret_id = each.key

  labels = {
    # This is a Secret text type credential, accessible to Jenkins via the GCP Secrets Manager Credentials Provider plugin
    jenkins-credentials-type = "string"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "controller_swarm_agent_auth_secret_version" {

  for_each = local.secrets

  secret = google_secret_manager_secret.controller_swarm_agent_auth_secret[each.key].id

  secret_data = each.value.version
}
