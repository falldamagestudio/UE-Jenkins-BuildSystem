resource "google_iap_brand" "project_brand" {
  support_email     = var.support_email
  application_title = "Jenkins (Cloud)"
}

resource "google_iap_client" "project_client" {
  display_name = "Test Client"
  brand        =  google_iap_brand.project_brand.name
}
