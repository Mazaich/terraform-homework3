resource "yandex_compute_disk" "storage_disks" {
  count = 3
  name     = "storage-disk-${count.index + 1}"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = 1 
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
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
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519_yandex.pub")}"
  }

  dynamic "secondary_disk" {
    for_each = { for idx, disk in yandex_compute_disk.storage_disks : idx => disk.id }
    content {
      disk_id = secondary_disk.value
    }
  }
}
