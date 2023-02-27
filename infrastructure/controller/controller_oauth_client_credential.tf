locals {

    oauth_client_credential = {

        OAUTH2_CLIENT_ID = {
          version = data.google_iap_client.build_system_oauth_client.client_id
        }

        OAUTH2_CLIENT_SECRET = {
          version = data.google_iap_client.build_system_oauth_client.secret
        }
    }
}

resource "google_secret_manager_secret" "oauth_client_credential" {

  for_each = local.oauth_client_credential

  secret_id = each.key

  labels = {
    # This is a Secret text type credential, accessible to Jenkins via the GCP Secrets Manager Credentials Provider plugin
    jenkins-credentials-type = "string"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "oauth_client_credential_version" {

  for_each = local.oauth_client_credential

  secret = google_secret_manager_secret.oauth_client_credential[each.key].id

  secret_data = each.value.version
}
