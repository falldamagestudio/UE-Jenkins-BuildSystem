output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = local.wait
}

output "ssh_vm_private_key_windows" {
  value = tls_private_key.ssh_vm_key.private_key_pem
}