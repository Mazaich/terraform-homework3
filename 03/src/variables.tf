variable "token" {
  type        = string
  description = "OAuth-токен"
}

variable "cloud_id" {
  type        = string
  description = "Идентификатор облака"
}

variable "folder_id" {
  type        = string
  description = "Идентификатор каталога"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона по умолчанию"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "CIDR по умолчанию"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "Имя VPC"
}

variable "web_vm_settings" {
  type = object({
    cpu         = number
    ram         = number
    boot_disk   = number
    platform_id = string
    disk_type   = string
  })
  default = {
    cpu         = 2
    ram         = 2
    boot_disk   = 5
    platform_id = "standard-v3"
    disk_type   = "network-hdd"
  }
  description = "Настройки веб-ВМ"
}

variable "storage_disks_settings" {
  type = object({
    count = number
    size  = number
    type  = string
  })
  default = {
    count = 3
    size  = 1
    type  = "network-hdd"
  }
  description = "Настройки дисков хранилища"
}

variable "storage_vm_settings" {
  type = object({
    cpu         = number
    ram         = number
    boot_disk   = number
    platform_id = string
    disk_type   = string
  })
  default = {
    cpu         = 2
    ram         = 2
    boot_disk   = 5
    platform_id = "standard-v3"
    disk_type   = "network-hdd"
  }
  description = "Настройки ВМ хранилища"
}

variable "os_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образов ОС"
}

variable "ssh_username" {
  type        = string
  default     = "ubuntu"
  description = "Имя пользователя SSH"
}

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
  description = "Параметры ВМ базы данных"
}

variable "security_group_ingress" {
  description = "Правила входящего трафика группы безопасности"
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "Разрешить SSH"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    },
    {
      protocol       = "TCP"
      description    = "Разрешить HTTP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    {
      protocol       = "TCP"
      description    = "Разрешить HTTPS"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    },
  ]
}

variable "security_group_egress" {
  description = "Правила исходящего трафика группы безопасности"
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "Разрешить весь исходящий трафик"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65365
    }
  ]
}

variable "ssh_public_key_path" {
  type        = string
  description = "Абсолютный путь к публичному SSH ключу"
}
