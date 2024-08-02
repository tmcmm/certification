resource "azurerm_public_ip" "main" {
  name                = "${var.vm_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

 lifecycle {
    ignore_changes = [
        tags
    ]
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "public"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  depends_on = [azurerm_public_ip.main, azurerm_network_interface.main]
  name                = "${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    #source_address_prefix      = "${var.mypublic_ip}"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_network_interface.main.private_ip_address
  }

  lifecycle {
    ignore_changes = [
        tags
    ]
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  depends_on = [azurerm_network_security_group.nsg]
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  
}

resource "azurerm_linux_virtual_machine" "main" {
  depends_on = [azurerm_public_ip.main, azurerm_network_interface.main,azurerm_network_security_group.nsg]
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = var.vm_size
  computer_name         = var.vm_name
  admin_username        = var.admin_username
  custom_data           = var.custom_data

  os_disk {
    name              = "${var.vm_name}-osdisk"
    #name              = "${var.vm_name}-${count.index}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type
  }

 admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.admin_ssh_public_key)
  }

  source_image_reference {
    offer     = lookup(var.os_disk_image, "offer", null)
    publisher = lookup(var.os_disk_image, "publisher", null)
    sku       = lookup(var.os_disk_image, "sku", null)
    version   = lookup(var.os_disk_image, "version", null)
  }

  tags = {
    environment = "kubeadm-cluster"
  }
}

