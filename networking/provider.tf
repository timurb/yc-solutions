provider "yandex" {
  cloud_id = var.cloud_id
  folder_id = var.folder_id
}


#  See landing-zone/README.md for configuration of the remote state
terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "zurdeploy-dev-terraform"      ###FIXME for your specific setup
    key        = "networking/terraform.tfstate" ###FIXME for your specific setup
    region     = "us-east-1"

    skip_region_validation      = true
    skip_credentials_validation = true
  }

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}