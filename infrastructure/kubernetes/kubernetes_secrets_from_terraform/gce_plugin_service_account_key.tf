# TODO: First, make kubernetes credentials provider able to create GoogleRobotPrivateKeyCredentials
# and then make this write a secret of that type, with the private key & project ID attached
#
## Make service account key available to Jenkins
## This will be picked up by the Kubernetes Credentials Provider plugin
##  and be visible in the Credentials manager in Jenkins
##
## Reference: https://jenkinsci.github.io/kubernetes-credentials-provider-plugin/examples/
## Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key
#
#resource "kubernetes_secret" "gce_plugin_service_account_key" {
#
#  metadata {
#    # Credential name is the identifier used in the withCredentials() call
#    name = "gce-plugin-service-account"
#    labels = {
#      "jenkins.io/credentials-type" = "secretFile"
#    }
#    annotations = {
#      "jenkins.io/credentials-description" : "Service Account used by Google Compute Engine plugin in Jenkins to control VMs"
#    }
#  }
#
#  type = "Opaque"
#
#  data = {
#    # Private key file (JSON format) for a service account in GCP
#    "data" = base64decode(google_service_account_key.gce_plugin_service_account_key.private_key)
#
#    # File name is not used in practice, but required by Jenkins nevertheless
#    "filename" = "gce_plugin-service-account-key.json"
#  }
#}
