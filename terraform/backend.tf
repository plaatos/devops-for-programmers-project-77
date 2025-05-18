# terraform/backend.tf
terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    bucket = "project-77"
    region = "ru-central1"
    key    = "devops-for-programmers-project-77/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum           = true
  }
}