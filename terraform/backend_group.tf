resource "yandex_alb_backend_group" "default" {
  name      = "backend-group"
  folder_id = var.folder_id

  http_backend {
    name             = "app-backend"
    weight           = 1
    port             = 3000
    target_group_ids = [yandex_alb_target_group.app-tg.id]

    healthcheck {
      timeout             = "30s"
      interval            = "15s"
      healthy_threshold   = 2
      unhealthy_threshold = 3

      http_healthcheck {
        path  = "/"
        http2 = false
      }
    }
  }
}
