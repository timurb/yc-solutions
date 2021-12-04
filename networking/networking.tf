resource "yandex_vpc_network" "default" {
  name = data.terraform_remote_state.landing-zone.outputs.environment
}

resource "yandex_vpc_subnet" "private" {
  count = 3

  name = "Private subnet ${count.index}"

  network_id = yandex_vpc_network.default.id
  v4_cidr_blocks = [cidrsubnet(var.cidr_base_private,8,count.index)]
  zone = var.zones[count.index]
  route_table_id = yandex_vpc_route_table.private.id
}

resource "yandex_vpc_subnet" "public" {
  count = 3
  network_id = yandex_vpc_network.default.id
  v4_cidr_blocks = [cidrsubnet(var.cidr_base_public,8,count.index)]
  zone = var.zones[count.index]
}

resource "yandex_vpc_address" "bastion" {
  name = "bastion"

  external_ipv4_address {
    zone_id = var.zones[0]
  }
}

resource "yandex_vpc_route_table" "private" {
  network_id = yandex_vpc_network.default.id

  name = "gw-default-private"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.bastion.network_interface[0].ip_address
  }
}
