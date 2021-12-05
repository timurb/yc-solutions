variable "app_name" {
  type = string
  default = "application"
}

variable "app_hostname" {
  type = string
  default = "application"
}

variable "platform_id" {
  type = string
  default = "standard-v3"
}

variable "cpu_cores" {
  type = number
  default = 2
}

variable "memory" {
  type = number
  default = 8
}

variable "root_disk_size" {
  type = number
  default = 30
}

variable "zone" {
  type = number
  default = 1
}
