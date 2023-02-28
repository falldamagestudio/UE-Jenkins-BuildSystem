output "ssh_vm_public_key_windows" {
  value = tls_private_key.ssh_vm_key.public_key_openssh
}

output "ssh_vm_private_key_windows" {
  value = tls_private_key.ssh_vm_key.private_key_pem
}