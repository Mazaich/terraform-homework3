output "web_vms_ips" {
  description = "Внешние IP-адреса веб-серверов"
  value = {
    for vm in yandex_compute_instance.web :
    vm.name => vm.network_interface[0].nat_ip_address
  }
}

output "database_vms_ips" {
  description = "Внешние IP-адреса серверов баз данных"
  value = {
    for vm_name, vm in yandex_compute_instance.database :
    vm.name => vm.network_interface[0].nat_ip_address
  }
}

output "storage_vm_ip" {
  description = "Внешний IP-адрес storage сервера"
  value = yandex_compute_instance.storage.network_interface[0].nat_ip_address
}

output "os_image_info" {
  description = "Информация об образе ОС"
  value = {
    id       = data.yandex_compute_image.ubuntu_image.id
    family   = data.yandex_compute_image.ubuntu_image.family
    name     = data.yandex_compute_image.ubuntu_image.name
    created  = data.yandex_compute_image.ubuntu_image.created_at
  }
}
