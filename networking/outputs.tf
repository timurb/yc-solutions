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

output "application_ip" {
  value = local.application_ip
}

output "application_fqdn" {
  value = local.application_dns
}

output "dns_zone" {
  value = local.dns_zone_fqdn
}
