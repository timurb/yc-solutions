data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

locals {
  ansible_gateway_string = "ansible_ssh_common_args: '-o ProxyCommand=\"ssh -W %h:%p -q ubuntu@${data.terraform_remote_state.networking.outputs.bastion_ip}\"'"
  ansible_inventory_string = "webapp  ansible_ssh_host=${yandex_compute_instance.docker-instance.network_interface[0].ip_address} ansible_ssh_user=ubuntu"
  instance_subnet = data.terraform_remote_state.networking.outputs.subnets_private[var.zone]
  instance_zone = data.terraform_remote_state.networking.outputs.zones[var.zone]
}

resource "yandex_compute_instance" "docker-instance" {
  name = var.app_name
  hostname = var.app_hostname

  platform_id = var.platform_id
  allow_stopping_for_update = true

  resources {
    cores = var.cpu_cores
    memory = var.memory
  }

  zone = local.instance_zone
  network_interface {
    subnet_id = local.instance_subnet
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size = var.root_disk_size
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.default
    content {
      disk_id = secondary_disk.value.id
      device_name = secondary_disk.value.labels.device_name
    }
  }

  service_account_id = data.terraform_remote_state.docker-registry.outputs.sa_pull

  metadata = {
    user-data = file("${path.module}/cloud-init.yaml")
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [boot_disk]
  }
}

resource "yandex_compute_disk" "default" {
  for_each = var.additional_disks

  name = "${var.app_name}-${each.key}"
  size = each.value["size"]
  type = each.value["type"]
  zone = local.instance_zone
  labels = {
    device_name = each.value["device"]
  }
}
