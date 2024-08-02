############################ ACCOUNT VARIABLES #############################
variable "client_id" {
  description = "The service principal id of client app. AKS uses this SP to create the required resources."
}

variable "client_secret" {
  description = "Service Principle Client Secret for AKS cluster (not used if using Managed Identity)"
}

variable "subscription_id" {
  description = "The subscription id from your account - az account show --subscription subsname --query id --output tsv"
}

variable "tenant_id" {
  description = "The tenant ID from your account - az account show --subscription subsname --query tenantId --output tsv"
}


##############################################################################
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "k8s-cluster-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Northeurope"
}

variable "vnet_name" {
  description = "Vnet name"
  default = "terraform-vnet"
}

variable "subnet_name" {
  description = "Subnet name"
  default = "terraform-snet"
}

variable "vnet_address_space" {
  description = "VNET CIDR"
  default = "10.0.0.0/22"
}

variable "snetaddress_space" {
  description = "SNET CIDR"
  default = "10.0.0.0/23"
}

variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = "terraformkubeadm"
}

variable "storage_account_key" {
  description = "Key for the storage account"
  type        = string
  sensitive   = true
}

variable "container_name" {
  description = "Name of the blob container"
  type        = string
  default     = "kubeadm"
}

variable "tags" {
  description = "(Optional) Specifies the tags terraform environment"
  default     = {}
}

variable "master_vm_size" {
  description = "size/type of VM to use for system node pool"
#  default     = "Standard_B2ms"
  default     = "Standard_D3_v2"
}

variable "worker_vm_size" {
  description = "size/type of VM to use for system node pool"
#  default     = "Standard_B2ms"
  default     = "Standard_D2_v2"
}

variable "ssh_public_key" {
    description = "SSH Key"
    default = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key" {
    description = "SSH Key"
    default = "~/.ssh/id_rsa"
}

variable "worker_vm_count" {
  description = "Number of workers to create"
  type    = number
  default = 2
}
