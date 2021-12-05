data "terraform_remote_state" "landing-zone" {
  backend = "local"

  config = {
    path = "../landing-zone/terraform.tfstate"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "zurdeploy-dev-terraform"           ###FIXME for your specific setup
    key        = "networking/terraform.tfstate" ###FIXME for your specific setup
    region     = "us-east-1"
    access_key = data.terraform_remote_state.landing-zone.outputs.terraform_access_key
    secret_key = data.terraform_remote_state.landing-zone.outputs.terraform_secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

data "terraform_remote_state" "docker-registry" {
  backend = "s3"
  config = {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "zurdeploy-dev-terraform"           ###FIXME for your specific setup
    key        = "docker-registry/terraform.tfstate" ###FIXME for your specific setup
    region     = "us-east-1"
    access_key = data.terraform_remote_state.landing-zone.outputs.terraform_access_key
    secret_key = data.terraform_remote_state.landing-zone.outputs.terraform_secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  cloud_id = data.terraform_remote_state.landing-zone.outputs.cloud_id
  folder_id = data.terraform_remote_state.landing-zone.outputs.folder_id
  zone = "ru-central1-c"
}


#  See landing-zone/README.md for configuration of the remote state
terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "zurdeploy-dev-terraform"           ###FIXME for your specific setup
    key        = "docker-instance/terraform.tfstate" ###FIXME for your specific setup
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
