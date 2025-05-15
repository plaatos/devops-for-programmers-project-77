resource "yandex_compute_instance" "server" {
  count = 2

  name                      = "server-${count.index + 1}"
  zone                      = var.zone
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    auto_delete = true
    mode        = "READ_WRITE"
    initialize_params {
      image_id = "fd85b6k7esmsatsjb6fr"
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.default-ru-central1-a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.alb-ibi.id]
  }

  metadata = {
    serial-port-enable = "1"
    ssh-keys           = var.ssh_keys
    user-data          = file("cloud-init.yaml")
  }

  scheduling_policy {
    preemptible = true
  }
}
