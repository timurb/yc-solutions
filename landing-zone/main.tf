resource "yandex_resourcemanager_folder" "default" {
  name = var.folder_name
  description = var.description
}
