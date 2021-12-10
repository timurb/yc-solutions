locals {
  dns_zone_name = replace(data.terraform_remote_state.landing-zone.outputs.environment,"-","")
  dns_zone_fqdn = "${local.dns_zone_name}.${var.base_dns}"
  basion_ip = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  bastion_dns = "bastion.${local.dns_zone_fqdn}"
  application_ip = yandex_vpc_address.application.external_ipv4_address[0].address
  application_dns = "application.${local.dns_zone_fqdn}"
}


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

  name = "Public subnet ${count.index}"

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

resource "yandex_vpc_address" "application" {
  name = "application"

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

resource "yandex_dns_zone" "public" {
  name = local.dns_zone_name
  description = "Public zone for ${local.dns_zone_name}"

  zone = "${local.dns_zone_fqdn}."
  public = true
}

resource "yandex_dns_recordset" "bastion" {
  zone_id = yandex_dns_zone.public.id
  name = "bastion"
  type = "A"
  ttl = 300
  data = [local.basion_ip]
}

resource "yandex_dns_recordset" "application" {
  zone_id = yandex_dns_zone.public.id
  name = "application"
  type = "A"
  ttl = 300
  data = [local.application_ip]
}
