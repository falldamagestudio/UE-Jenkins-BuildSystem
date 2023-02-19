resource "tls_private_key" "controller_vm_ansible_key" {

  algorithm   = "RSA"
  rsa_bits    = "4096"
}
