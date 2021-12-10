data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

locals {
  ansible_gateway_string = "ansible_ssh_common_args: '-o ProxyCommand=\"ssh -W %h:%p -q ubuntu@${data.terraform_remote_state.networking.outputs.bastion_ip}\"'"
  ansible_inventory_string = "application  ansible_ssh_host=${yandex_compute_instance.docker-instance.network_interface[0].ip_address} ansible_ssh_user=ubuntu"
  instance_subnet = data.terraform_remote_state.networking.outputs.subnets_private[var.zone]
  instance_zone = data.terraform_remote_state.networking.outputs.zones[var.zone]
}

resource "yandex_compute_instance" "docker-instance" {
  name = var.app_name
  hostname = var.app_hostname

  platform_id = var.platform_id
  allow_stopping_for_update = false

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

  service_account_id = data.terraform_remote_state.docker-registry.outputs.sa_pull

  metadata = {
    user-data = file("${path.module}/cloud-init.yaml")
  }

  lifecycle {
    ignore_changes = [boot_disk]
  }
}
