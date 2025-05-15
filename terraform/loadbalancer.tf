# loadbalancer.tf

resource "yandex_alb_load_balancer" "app-lb" {
  name        = "load-balancer"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.default-network.id

  allocation_policy {
    location {
      zone_id   = var.zone
      subnet_id = yandex_vpc_subnet.default-ru-central1-a.id
    }
  }

  listener {
    name = "http"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }

  listener {
    name = "https"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [443]
    }
    tls {
      default_handler {
        certificate_ids = ["fpq1gmm0m3focnv54vcp"]
        http_handler {
          http_router_id = yandex_alb_http_router.http-router.id
        }
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX"]
      discard_percent     = 75
    }
  }

  security_group_ids = [yandex_vpc_security_group.alb-ibi.id]
}
