output "subnets_private" {
  value = yandex_vpc_subnet.private.*.id
}

output "subnets_public" {
  value = yandex_vpc_subnet.public.*.id
}

output "bastion_ip" {
  value = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}
