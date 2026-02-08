variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  
  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 2
      disk_volume = 10
    },
    {
      vm_name     = "replica"
      cpu         = 4
      ram         = 4
      disk_volume = 20
    }
  ]
}

resource "yandex_compute_instance" "database" {
  for_each = toset(["0", "1"])
  name = var.each_vm[each.key].vm_name
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

resources {
  cores  = var.each_vm[each.key].cpu
  memory = var.each_vm[each.key].ram
  }

  
boot_disk {
  initialize_params {
    image_id = "fd8vmcue7aajpmeo39kk"
    size     = var.each_vm[each.key].disk_volume
    type     = "network-hdd"
  }
}

network_interface {
  subnet_id = "e9b84ehhf52u1gcvsmtp"
  nat       = true
}

metadata = {
  ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519_yandex.pub")}"
  }
}
