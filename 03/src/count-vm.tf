resource "yandex_compute_instance" "web" {
  count = 2
  name = "web-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2  
    memory = 2  
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"
      size     = 5
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = "e9b84ehhf52u1gcvsmtp"
    nat       = true
    security_group_ids = ["enphqc9tcksgqlbqu2cv"]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519_yandex.pub")}"
  }

  depends_on = [
    yandex_compute_instance.database
  ]
}
