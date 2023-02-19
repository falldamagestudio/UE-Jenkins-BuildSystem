output "controller_vm_ansible_private_key" {
  value = tls_private_key.controller_vm_ansible_key.private_key_pem
  sensitive = true
}