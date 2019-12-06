variable "project" {
  default = "pans-91"
}

variable "region" {
  default = "asia-south1"
}

variable "zone" {
  default = "asia-south1-a"
}

variable "master_image" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}
variable "master_image_ubuntu" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}
variable "master_image_centos" {
  default = "centos-cloud/centos-7"
}

variable "size" {
  default = 100
}

variable "machine_type" {
  default = "n1-standard-2"
}

variable "user" {
  default = "kaladin" # TODO: Username on local system (run `whoami` to get this value).
}

