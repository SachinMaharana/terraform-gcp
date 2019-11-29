resource "google_compute_network" "k8s_network" {
  auto_create_subnetworks = false
  name = "k8s-network"
}

resource "google_compute_subnetwork" "k8s_subnet" {
  name = "k8s-subnet"
  ip_cidr_range = "10.240.0.0/24"
  region = var.region
  network = google_compute_network.k8s_network.self_link

}

resource "google_compute_firewall" "k8s_externalfirewall" {
  name = "k8s-externalfirewall"
  network = google_compute_network.k8s_network.name
  allow {
    
      protocol = "icmp"
  }
  allow {
      ports = ["6443", "22"]
      protocol = "tcp"
  }
  allow {
      protocol = "udp"
      
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "k8s_internalfirewall" {
  name = "k8s-internalfirewall"
  network = google_compute_network.k8s_network.name
  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]

  allow {
      protocol = "icmp"
  }
  
  allow {
      ports = ["22"]
      protocol = "tcp"
  }

  allow {
      protocol = "udp"
  }
}



