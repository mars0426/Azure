resource "azurerm_network_interface" "example" {
  ip_configuration {
    name                          = "example-ip-configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
}
