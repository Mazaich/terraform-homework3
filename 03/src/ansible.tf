data "template_file" "ansible_inventory" {
  template = file("${path.module}/templates/inventory.tpl")
  
  vars = {
    webservers = jsonencode([
      for vm in yandex_compute_instance.web : {
        name        = vm.name
        external_ip = vm.network_interface[0].nat_ip_address
        fqdn        = vm.fqdn
        type        = "web"
      }
    ])
    
    databases = jsonencode([
      for vm_name, vm in yandex_compute_instance.database : {
        name        = vm.name
        external_ip = vm.network_interface[0].nat_ip_address
        fqdn        = vm.fqdn
        type        = "database"
      }
    ])
    
    storage = jsonencode([{
      name        = yandex_compute_instance.storage.name
      external_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      fqdn        = yandex_compute_instance.storage.fqdn
      type        = "storage"
    }])
    
    ssh_user = var.ssh_username
    ssh_key_path = var.ssh_public_key_path
  }
}

resource "local_file" "inventory" {
  filename = "${path.module}/inventory.ini"
  content  = data.template_file.ansible_inventory.rendered
  
  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.database,
    yandex_compute_instance.storage
  ]
}
