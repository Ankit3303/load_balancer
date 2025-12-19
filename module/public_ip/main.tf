resource "azurerm_public_ip" "public_ips" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic" 
}
