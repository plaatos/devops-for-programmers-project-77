# Используем существующую DNS-зону из папки b1gcijne0kpqqgce0uld
data "yandex_dns_zone" "test_step_ru" {
  name      = "test-step-zone"
  folder_id = "b1gcijne0kpqqgce0uld"
}

# Создаем A-запись для test-step.ru
resource "yandex_dns_recordset" "test_step_ru" {
  zone_id = data.yandex_dns_zone.test_step_ru.id
  name    = "@"
  type    = "A"
  ttl     = 300
  data = [
    yandex_alb_load_balancer.app-lb.listener[0].endpoint[0].address[0].external_ipv4_address[0]
  ]
}