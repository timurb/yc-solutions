data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

# Bastion + NAT Gateway
resource "yandex_compute_instance" "docker-instance" {
  name = var.app_name
  hostname = var.app_hostname

  platform_id = var.platform_id
  allow_stopping_for_update = false

  resources {
    cores = var.cpu_cores
    memory = var.memory
  }

  zone = data.terraform_remote_state.networking.outputs.zones[var.zone]
  network_interface {
    subnet_id = data.terraform_remote_state.networking.outputs.subnets_private[var.zone]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  metadata = {
    user-data = file("${path.module}/cloud-init.yaml")
  }

  lifecycle {
    ignore_changes = [boot_disk]
  }
}
