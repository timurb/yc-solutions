output "folder_id" {
  value = yandex_resourcemanager_folder.default.id
}

output "folder_name" {
  value = yandex_resourcemanager_folder.default.name
}

output "terraform_bucket" {
  value = yandex_storage_bucket.terraform.bucket
}

output "terraform_service_account_id" {
  value = yandex_iam_service_account.terraform-state.id
}

output "terraform_access_key" {
  value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
}

output "terraform_secret_key" {
  value = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive = true
}
