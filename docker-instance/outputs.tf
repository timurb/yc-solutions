output "docker_fqdn" {
  value = yandex_compute_instance.docker-instance.fqdn
}

output "docker_ip" {
  value = yandex_compute_instance.docker-instance.network_interface[0].ip_address
}

output "application_ip" {
  value = data.terraform_remote_state.networking.outputs.application_ip
}

output "ansible_configs" {
  value = [
    local.ansible_gateway_string,
    local.ansible_inventory_string
  ]
}
