resource "yandex_compute_instance" "web" {
  count = 2
  name = "web-${count.index + 1}"
  platform_id = var.web_vm_settings.platform_id
  zone        = var.default_zone

  resources {
    cores  = var.web_vm_settings.cpu
    memory = var.web_vm_settings.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
      size     = var.web_vm_settings.boot_disk
      type     = var.web_vm_settings.disk_type
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

  depends_on = [yandex_compute_instance.database]
}
