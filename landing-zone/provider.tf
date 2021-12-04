provider "yandex" {
  alias = "cloud"
  cloud_id = var.cloud_id
}

provider "yandex" {
  alias = "folder"
  cloud_id = var.cloud_id
  folder_id = yandex_resourcemanager_folder.default.id
}


terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
