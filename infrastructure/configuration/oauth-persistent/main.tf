module "google_apis" {
  source = "../../services/google_apis"
}

module "oauth" {
  depends_on = [module.google_apis]
  source = "../../services/oauth"

  support_email = var.support_email
}
