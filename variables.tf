variable "project" {
  default = "dogs23"
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

variable "size" {
  default = 100
}

variable "machine_type" {
  default = "n1-standard-2"
}

variable "user" {
  default = "kaladin" # TODO: Username on local system (run `whoami` to get this value).
}

