resource "google_compute_instance" "k8s-master" {
  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.master_image
      size  = var.size
    }
  }
  zone         = var.zone
  name         = "k8s-master"
  machine_type = var.machine_type

  can_ip_forward = true
  network_interface {
    access_config {}
    subnetwork = google_compute_subnetwork.k8s_subnet.name
    network_ip = "10.240.0.11"
  }

  service_account {
    scopes = ["compute-rw", "userinfo-email", "compute-ro", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  metadata =  {
    creator = var.user
  }

  tags = ["worker"]

}

resource "google_compute_instance" "k8s-worker" {
  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.master_image
      size  = var.size
    }
  }
  zone         = var.zone
  name         = "k8s-worker-${count.index}"
  machine_type = var.machine_type

  can_ip_forward = true
  count          = 2
  network_interface {
    access_config {}
    subnetwork = google_compute_subnetwork.k8s_subnet.name
    network_ip = "10.240.0.2${count.index}"
  }

  service_account {
    scopes = ["compute-rw", "userinfo-email", "compute-ro", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  metadata = {
    creator  = var.user
    pod-cidr = "10.200.${count.index}.0/16"
  }
  tags = ["worker"]
}

kubeadm init --pod-network-cidr 10.200.0.0/16 