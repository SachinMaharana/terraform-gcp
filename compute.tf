resource "google_compute_instance" "k8s-master" {
  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.master_image_ubuntu
      size  = var.size
    }
  }
  zone         = var.zone
  name         = "k8s-master-0${count.index + 1}"
  machine_type = var.machine_type
  count        = 3

  can_ip_forward = true
  network_interface {
    access_config {}
    subnetwork = google_compute_subnetwork.k8s_subnet.name
    network_ip = "10.240.0.${count.index + 2}"
  }

  service_account {
    scopes = ["compute-rw", "userinfo-email", "compute-ro", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  metadata = {
    creator = var.user
  }

  tags = ["master"]

}

resource "google_compute_instance" "k8s-worker" {
  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.master_image_ubuntu
      size  = var.size
    }
  }
  zone         = var.zone
  name         = "k8s-worker-0${count.index + 1}"
  machine_type = "n1-standard-1"

  can_ip_forward = true
  count          = 3
  network_interface {
    access_config {}
    subnetwork = google_compute_subnetwork.k8s_subnet.name
    network_ip = "10.240.0.${count.index + 8}"
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

resource "google_compute_instance" "k8s-etcd" {
  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.master_image_ubuntu
      size  = var.size
    }
  }
  zone         = var.zone
  name         = "k8s-etcd-0${count.index + 1}"
  machine_type = "f1-micro"

  can_ip_forward = true
  count          = 3
  network_interface {
    access_config {}
    subnetwork = google_compute_subnetwork.k8s_subnet.name
    network_ip = "10.240.0.${count.index + 5}"
  }

  service_account {
    scopes = ["compute-rw", "userinfo-email", "compute-ro", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  metadata = {
    creator = var.user
    # pod-cidr = "10.200.${count.index}.0/16"
  }
  tags = ["etcd"]
}





resource "google_compute_instance" "k8s-haproxy" {
  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.master_image_ubuntu
      size  = var.size
    }
  }
  zone         = var.zone
  name         = "k8s-haproxy"
  machine_type = "g1-small"

  can_ip_forward = true
  # count          = 3
  network_interface {
    access_config {}
    subnetwork = google_compute_subnetwork.k8s_subnet.name
    network_ip = "10.240.0.11"
  }

  service_account {
    scopes = ["compute-rw", "userinfo-email", "compute-ro", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  metadata = {
    creator = var.user
    # pod-cidr = "10.200.${count.index}.0/16"
  }
  tags = ["haproxy"]
}

#kubeadm init --pod-network-cidr 10.200.0.0/16 
