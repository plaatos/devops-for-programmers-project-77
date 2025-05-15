# virtual_host.tf

resource "yandex_alb_virtual_host" "vh" {
  name           = "vh-test-step"
  http_router_id = yandex_alb_http_router.http-router.id
  authority      = ["test-step.ru"]

  route {
    name = "main-route"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.default.id
        timeout          = "10s"
        idle_timeout     = "30s"
      }
    }
  }

  route_options {
    rbac {
      action = "ALLOW"
      principals {
        and_principals {
          any = true
        }
      }
    }
  }
}
