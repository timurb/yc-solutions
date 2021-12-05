output "registry_id" { value = yandex_container_registry.default.id }

output "sa_push_key_secret_key" {
  value = jsonencode(yandex_iam_service_account_key.push)
  sensitive = true
}

output "sa_pull_key_secret_key" {
  value = jsonencode(yandex_iam_service_account_key.pull)
  sensitive = true
}


