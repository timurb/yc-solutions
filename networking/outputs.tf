output "network" {
  value = yandex_vpc_network.default.id
}

output "subnets_private" {
  value = yandex_vpc_subnet.private.*.id
}

output "subnets_public" {
  value = yandex_vpc_subnet.public.*.id
}

output "zones" {
  value = var.zones
}

output "bastion_ip" {
  value = local.basion_ip
}

output "bastion_fqdn" {
  value = local.bastion_dns
}

output "webapp_ip" {
  value = local.webapp_ip
}

output "webapp_fqdn" {
  value = local.webapp_dns
}

output "dns_zone" {
  value = local.dns_zone_fqdn
}
