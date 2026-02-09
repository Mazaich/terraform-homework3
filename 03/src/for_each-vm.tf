variable "database_vms" {
  type = map(object({
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  
  default = {
    "main" = {
      cpu         = 2
      ram         = 2
      disk_volume = 10
    },
    "replica" = {
      cpu         = 4
      ram         = 4
      disk_volume = 20
    }
  }
}

resource "yandex_compute_instance" "database" {
  for_each = var.database_vms
  name = each.key
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"
      size     = each.value.disk_volume
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519_yandex.pub")}"
  }
}
