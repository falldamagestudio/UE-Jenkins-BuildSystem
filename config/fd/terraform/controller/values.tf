output "controller_vm_ansible_private_key" {
  value = module.controller.controller_vm_ansible_private_key
  sensitive = true
}

output "controller_vm_service_account_key" {
  value = module.controller.controller_vm_service_account_key
  sensitive = true
}
