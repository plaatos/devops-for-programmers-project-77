resource "yandex_vpc_network" "default-network" {
  name = "default-network"
}

resource "yandex_vpc_subnet" "default-ru-central1-a" {
  name           = "default-ru-central1-a"
  zone           = var.zone
  network_id     = yandex_vpc_network.default-network.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}