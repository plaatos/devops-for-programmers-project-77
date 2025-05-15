# target_group.tf

resource "yandex_alb_target_group" "app-tg" {
  name      = "app-target-group"
  folder_id = var.folder_id

  target {
    ip_address  = yandex_compute_instance.server[0].network_interface[0].ip_address
    subnet_id   = yandex_vpc_subnet.default-ru-central1-a.id
  }

  target {
    ip_address  = yandex_compute_instance.server[1].network_interface[0].ip_address
    subnet_id   = yandex_vpc_subnet.default-ru-central1-a.id
  }
}
