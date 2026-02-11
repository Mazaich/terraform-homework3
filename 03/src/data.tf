data "yandex_compute_image" "ubuntu_image" {
  family    = var.os_image_family
  folder_id = "standard-images"
}
