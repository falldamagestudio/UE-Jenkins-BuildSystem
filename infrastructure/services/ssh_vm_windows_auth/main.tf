locals {
  wait = length(tls_private_key.ssh_vm_key.id)
}

// SSH agents for Windows will use a shared key pair for authentication
// GCE has a built-in mechanism for this for Linux OS, but nothing
//  similar exists for Windows; thus we invent the same but via Secrets Manager
//  instead of via instance metadata

resource "tls_private_key" "ssh_vm_key" {

  depends_on = [ var.module_depends_on ]

  algorithm   = "RSA"
  rsa_bits    = "4096"
}
