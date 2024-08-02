output "public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "network_interface_id" {
  value = azurerm_network_interface.main.id
}
