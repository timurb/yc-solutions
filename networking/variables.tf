#variable "cloud_id" {}
#variable "folder_id" {}
#variable "environment" {}

variable "cidr_base_private" {
  type = string
  default = "10.21.0.0/16"
}

variable "cidr_base_public" {
  type = string
  default = "10.121.0.0/16"
}

variable "zones" {
  type = list(string)
  default = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
  ]
}

variable "base_dns" {
  type = string
  default = "yc.timurb.ru"
}
