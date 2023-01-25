data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "outline" {
  name = "outline"

  platform_id = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores = 2
    memory = 1
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = var.subnet_id
    nat = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    ignore_changes = [boot_disk]
  }

  provisioner "remote-exec" {
    inline = ["curl https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh | sudo bash"]

    connection {
      host = self.network_interface.0.nat_ip_address
      type = "ssh"
      user = "ubuntu"
      agent = true
    }
  }
}

output "private_ip" {
  value = yandex_compute_instance.outline.network_interface[0].ip_address
}


output "public_ip" {
  value = yandex_compute_instance.outline.network_interface[0].nat_ip_address
}

