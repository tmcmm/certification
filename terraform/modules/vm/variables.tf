variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable admin_username {
  description = "(Required) Specifies the username of the virtual machine"
  type        = string
  default     = "azureuser"
}

variable "ssh_private_key" {
    description = "SSH Key"
    default = "~/.ssh/id_rsa"
}

variable "admin_ssh_public_key" {
  description = "Specifies the public SSH key"
  type        = string
  default = "~/.ssh/id_rsa.pub"
}

variable "node_role" {
  description = "Role of the node (master or worker)"
  type        = string
}

variable "vm_size" {
  description = "size/type of VM to use for system node pool"
  default     = "Standard_D3_v2"
}

variable "tags" {
  description = "(Optional) Specifies the tags terraform environment"
  default     = {}
}

variable "mypublic_ip" {
  description = "My provider public IP"
  type        = string
  default     = ""
}

variable "os_disk_image" {
  type        = map(string)
  description = "(Optional) Specifies the os disk image of the virtual machine"
  default     = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts" 
    version   = "latest"
  #offer     = "UbuntuServer"
  #sku       = "18.04-LTS"

  }
}

variable "os_disk_storage_account_type" {
  description = "(Optional) Specifies the storage account type of the os disk of the virtual machine"
  default     = "StandardSSD_LRS"
  type        = string

  validation {
    condition = contains(["Premium_LRS", "Premium_ZRS", "StandardSSD_LRS", "StandardSSD_ZRS",  "Standard_LRS"], var.os_disk_storage_account_type)
    error_message = "The storage account type of the OS disk is invalid."
  }
}

variable "custom_data" {
  description = "My custom script"
  type        = string
}

/* 
variable "vm_instances" {
  description = "Map of VM instances to create"
  type = map(object({
    vm_name             = string
    vm_size             = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    admin_username      = string
    admin_password      = string
    ssh_private_key     = string
    node_role           = string
    storage_account_name = string
    storage_account_key  = string
    container_name       = string
  }))
} */