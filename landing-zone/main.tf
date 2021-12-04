resource "yandex_resourcemanager_folder" "default" {
  name = var.folder_name
  description = var.description

  provider = yandex.cloud
}

resource "yandex_iam_service_account" "terraform-state" {
  folder_id = yandex_resourcemanager_folder.default.id
  name      = "terraform"

  provider = yandex.folder
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = yandex_resourcemanager_folder.default.id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-state.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.terraform-state.id
  description        = "Terraform static access key for object storage"
}

resource "yandex_storage_bucket" "terraform" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key

  bucket = "${var.folder_name}-terraform"

  depends_on = [
    yandex_iam_service_account_static_access_key.sa-static-key,
    yandex_iam_service_account.terraform-state
  ]
  provider = yandex.folder
}
