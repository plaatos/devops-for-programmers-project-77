# main.tf
terraform {
  # Требуемая версия Terraform (>= v1.0)
  required_version = ">= 1.0"

  # Используем провайдер Yandex Cloud
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.141.0" 
    }
  }
}
