resource "yandex_vpc_security_group" "alb-ibi" {
  name       = "alb-ibi"
  network_id = yandex_vpc_network.default-network.id

  ingress {
    protocol         = "TCP"
    from_port        = 3000
    to_port          = 3000
    predefined_target = "loadbalancer_healthchecks"
    description      = "Allow ALB health checks on port 3000"
  }
  
  ingress {
    protocol       = "TCP"
    from_port      = 3000
    to_port        = 3000
    v4_cidr_blocks = ["10.130.0.0/24"] # Подсеть ALB и backend'ов
    description    = "Allow traffic from ALB to backend"
  }

  ingress {
    protocol         = "TCP"
    from_port        = 30080
    to_port          = 30080
    predefined_target = "loadbalancer_healthchecks"
    description      = "Allow ALB internal communication for health checks"
  }

  ingress {
    protocol       = "TCP"
    from_port      = 80
    to_port        = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow HTTP traffic from anywhere"
  }
  
  ingress {
    protocol       = "TCP"
    from_port      = 443
    to_port        = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow HTTPS traffic from anywhere"
  }

  ingress {
    protocol       = "TCP"
    from_port      = 22
    to_port        = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow SSH access from anywhere"
  }

  egress {
    protocol       = "ANY"
    from_port      = -1
    to_port        = -1
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow all outbound traffic"
  }
}