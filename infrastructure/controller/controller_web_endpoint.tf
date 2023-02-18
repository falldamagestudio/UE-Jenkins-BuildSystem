
data "google_project" "project" {
  project_id = var.project_id
}

data "google_iap_client" "build_system_oauth_client" {
  brand = "projects/${data.google_project.project.number}/brands/${data.google_project.project.number}"
  client_id = var.oauth2_client_id
}

module "controller_web_endpoint" {
  source               = "GoogleCloudPlatform/lb-http/google"
  version              = "~> 6.0"
  name                 = "controller-web-endpoint"
  project              = var.project_id

  # Target networks which the firewall rules shall be injected into
  firewall_networks    = [var.controller_vm_network]

  # Enable SSL support
  ssl                  = true
  # Do not provide any SSL certificates; the lb-http module will create Google-managed SSL certificates
  use_ssl_certificates = false

  # Domains, for which we want Google-managed SSL certificates
  managed_ssl_certificate_domains = [ var.controller_web_endpoint_domain ]

  # Enable HTTPS-to-HTTP redirect
  https_redirect       = true

  # Disable automatic forwarding of port 80
  http_forward        = false

  backends = {
    controller = {
      description                     = null
      protocol                        = "HTTP"
      port                            = 8080
      port_name                       = "http"
      timeout_sec                     = 10
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null
      custom_response_headers         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/login"
        port                = 8080
        host                = null
        logging             = null
      }

      log_config = {
        enable      = false
        sample_rate = null
      }

      groups = [
        {
          group                        = google_compute_network_endpoint_group.neg.id
          # Zonal NEGs support only "RATE" balancing mode
          # Reference: https://cloud.google.com/load-balancing/docs/backend-service#balancing-mode
          balancing_mode               = "RATE"
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          # Very high max rate set, since we want all traffic to go to our single endpoint
          max_rate                     = 1000000
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        }
      ]
      iap_config = {
        enable               = false
        oauth2_client_id     = data.google_iap_client.build_system_oauth_client.client_id
        oauth2_client_secret = data.google_iap_client.build_system_oauth_client.secret
      }
    }
  }
}
