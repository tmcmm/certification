resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  depends_on = [azurerm_resource_group.main]
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
        tags
    ]
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes      = [var.snetaddress_space]
}

module "master_vm" {
  source               = "./modules/vm"
  vm_name              = "k8s-master"
  vm_size              = var.master_vm_size
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  subnet_id            = azurerm_subnet.subnet.id
  admin_username       = var.admin_username
  ssh_private_key      = var.ssh_private_key
  node_role            = "master"
/*   storage_account_name = var.storage_account_name
  storage_account_key  = var.storage_account_key
  container_name       = var.container_name */
  custom_data  = base64encode(templatefile("${path.module}/modules/vm/scripts/master-script.sh", {
    STORAGE_ACCOUNT_NAME =var.storage_account_name,
    STORAGE_ACCOUNT_KEY=var.storage_account_key,
    CONTAINER_NAME=var.container_name,
    LOG_FILE="/var/log/master-script.log"
  }))
}

module "worker_vm_1" {
  depends_on = [module.master_vm]
  source               = "./modules/vm"
  vm_name              = "k8s-worker-1"
  vm_size              = var.worker_vm_size
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  subnet_id            = azurerm_subnet.subnet.id
  admin_username       = var.admin_username
  ssh_private_key      = var.ssh_private_key
  node_role            = "worker"
  #custom_data =  filebase64("./modules/vm/scripts/worker-script.sh" ,{ STORAGE_ACCOUNT_NAME = var.storage_account_name})
  custom_data  = base64encode(templatefile("${path.module}/modules/vm/scripts/worker-script.sh", {
    STORAGE_ACCOUNT_NAME =var.storage_account_name,
    STORAGE_ACCOUNT_KEY=var.storage_account_key,
    CONTAINER_NAME=var.container_name,
    LOG_FILE="/var/log/worker1-script.log"
  }))
}

module "worker_vm_2" {
  depends_on = [module.master_vm]
  source               = "./modules/vm"
  vm_name              = "k8s-worker-2"
  vm_size              = var.worker_vm_size
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  subnet_id            = azurerm_subnet.subnet.id
  admin_username       = var.admin_username
  ssh_private_key      = var.ssh_private_key
  node_role            = "worker"
  custom_data  = base64encode(templatefile("${path.module}/modules/vm/scripts/worker-script.sh", {
    STORAGE_ACCOUNT_NAME = var.storage_account_name,
    STORAGE_ACCOUNT_KEY  = var.storage_account_key,
    CONTAINER_NAME       = var.container_name,
    LOG_FILE="/var/log/worker2-script.log"
  }))
}