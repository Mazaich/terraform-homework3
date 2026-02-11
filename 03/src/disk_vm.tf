resource "yandex_compute_disk" "storage_disks" {
  count = var.storage_disks_settings.count
  
  name = "storage-disk-${count.index + 1}"
  type = var.storage_disks_settings.type
  zone = var.default_zone
  size = var.storage_disks_settings.size
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.storage_vm_settings.platform_id
  zone        = var.default_zone

  resources {
    cores  = var.storage_vm_settings.cpu
    memory = var.storage_vm_settings.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
      size     = var.storage_vm_settings.boot_disk
      type     = var.storage_vm_settings.disk_type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_public_key_path)}"
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disks
    content {
      disk_id = secondary_disk.value.id
    }
  }
}
