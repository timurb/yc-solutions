data "yandex_compute_image" "nat-gateway" {
  family = "nat-instance-ubuntu"
}

# Bastion + NAT Gateway
resource "yandex_compute_instance" "bastion" {
  name = "bastion"
  hostname = "bastion"

  platform_id = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores = 2
    memory = 2
  }

  zone = "ru-central1-a"
  network_interface {
    subnet_id = yandex_vpc_subnet.public[0].id  # must match ru-central1-a
    nat = true
    nat_ip_address = yandex_vpc_address.bastion.external_ipv4_address[0].address
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat-gateway.id
    }
  }

  metadata = {
    user-data = file("${path.module}/cloud-init.yaml")
  }

  lifecycle {
    ignore_changes = [boot_disk]
  }
}
