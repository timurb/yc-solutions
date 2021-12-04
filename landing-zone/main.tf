resource "yandex_resourcemanager_folder" "default" {
  name = var.folder_name
  description = var.description

  provider = yandex.cloud
}

resource "yandex_storage_bucket" "terraform" {
  bucket = "${var.folder_name}-terraform"

  provider = yandex.folder
}
