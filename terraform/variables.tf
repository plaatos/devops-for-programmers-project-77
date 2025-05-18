# terraform/variables.tf

variable "yc_token" {
  type      = string
  default   = "mock-token-for-ci"
  sensitive = true
}

variable "cloud_id" {
  type    = string
  default = "mock-cloud-id"
}

variable "folder_id" {
  type    = string
  default = "mock-folder-id"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "ssh_keys" {
  type        = string
  default     = "michel:mock-ssh-key"
  sensitive   = true
  description = "SSH-ключи для доступа к ВМ"
}

variable "datadog_api_key" {
  type      = string
  default   = "mock-datadog-api-key"
  sensitive = true
}
