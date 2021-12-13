variable "app_name" {
  type = string
  default = "webapp"
}

variable "app_hostname" {
  type = string
  default = "webapp"
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

variable "additional_disks" {
  type = map(object({
    device = string,
    size = number,
    type = string
  }))
  default = {}
}

variable "zone" {
  type = number
  default = 1
}
