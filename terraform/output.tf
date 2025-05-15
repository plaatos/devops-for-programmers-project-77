# output.tf

output "server_public_ips" {
  value       = yandex_compute_instance.server[*].network_interface.0.nat_ip_address
  description = "Список публичных IP-адресов серверов"
}

output "server_private_ips" {
  value       = yandex_compute_instance.server[*].network_interface.0.ip_address
  description = "Список приватных IP-адресов серверов"
}

output "server_ids" {
  value       = yandex_compute_instance.server[*].id
  description = "Список ID серверов"
}

output "server_names" {
  value       = yandex_compute_instance.server[*].name
  description = "Список имён серверов"
}

output "dns_zone_name" {
  value       = data.yandex_dns_zone.test_step_ru.zone
  description = "Название DNS зоны"
}

output "dns_zone_public" {
  value       = data.yandex_dns_zone.test_step_ru.public
  description = "Является ли зона публичной"
}

output "subnet_name" {
  value       = yandex_vpc_subnet.default-ru-central1-a.name
  description = "Название подсети"
}

output "network_id" {
  value       = yandex_vpc_subnet.default-ru-central1-a.network_id
  description = "ID сети, к которой привязана подсеть"
}

output "alb_status" {
  value       = yandex_alb_load_balancer.app-lb.status
  description = "Статус Application Load Balancer"
}
