resource "azurerm_virtual_network" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  location            = var.location
  tags                = var.tags
}

resource "azurerm_subnet" "example" {
  name                 = "Subnet1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.subnet_address_prefix
}
