resource "yandex_vpc_security_group" "example" {
  name       = "example_dynamic"
  network_id = yandex_vpc_network.develop.id
  folder_id  = var.folder_id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol       = ingress.value.protocol
      description    = ingress.value.description
      port           = ingress.value.port
      from_port      = ingress.value.from_port
      to_port        = ingress.value.to_port
      v4_cidr_blocks = ingress.value.v4_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = egress.value.protocol
      description    = egress.value.description
      port           = egress.value.port
      from_port      = egress.value.from_port
      to_port        = egress.value.to_port
      v4_cidr_blocks = egress.value.v4_cidr_blocks
    }
  }
}
