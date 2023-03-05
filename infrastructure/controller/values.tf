output "controller_vm_ansible_private_key" {
  value = tls_private_key.controller_vm_ansible_key.private_key_pem
  sensitive = true
}

output "controller_vm_service_account_key" {
  value = base64decode(google_service_account_key.controller_service_account_key.private_key)
  sensitive = true
}

output "swarm_agent_username" {
  value = local.secrets.swarm_agent_username
}

output "swarm_agent_api_token" {
  value = local.secrets.swarm_agent_api_token
  sensitive = true
}
