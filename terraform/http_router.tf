resource "yandex_alb_http_router" "http-router" {
  name      = "http-router"
  folder_id = var.folder_id
}