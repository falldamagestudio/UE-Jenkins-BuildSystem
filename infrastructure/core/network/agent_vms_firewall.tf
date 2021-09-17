resource "google_compute_firewall" "agent_vms_allow_winrm" {
  depends_on = [ var.module_depends_on ]

  name = "agent-vms-allow-winrm"
  
  network = google_compute_network.agent_vms.name

  description = "Allow WinRM to agent VMs"

  allow {
    protocol = "tcp"
    ports = [ "5985","5986" ]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

resource "google_compute_firewall" "agent_vms_allow_ssh" {
  depends_on = [ var.module_depends_on ]

  name = "agent-vms-allow-ssh"
  
  network = google_compute_network.agent_vms.name

  description = "Allow SSH to agent VMs"

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

resource "google_compute_firewall" "agent_vms_allow_rdp" {
  depends_on = [ var.module_depends_on ]

  name = "agent-vms-allow-rdp"

  network = google_compute_network.agent_vms.name

  description = "Allow Remote Desktop to agent VMs"

  allow {
      protocol = "tcp"
      ports = [ "3389" ]
  }

  allow {
    protocol = "udp"
    ports = [ "3389" ]
  }

  source_ranges = [ "0.0.0.0/0" ]
}
