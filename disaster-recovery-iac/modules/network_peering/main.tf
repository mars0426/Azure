resource "azurerm_virtual_network_peering" "first-to-second" {
  name                         = var.first_to_second_name
  virtual_network_name         = var.first_virtual_network_name
  remote_virtual_network_id    = var.second_virtual_network_id
  resource_group_name          = var.resource_group_name
  allow_virtual_network_access = var.first_allow_virtual_network_access
  allow_forwarded_traffic      = var.first_allow_forwarded_traffic
  allow_gateway_transit        = var.first_allow_gateway_transit
}

resource "azurerm_virtual_network_peering" "second-to-first" {
  name                         = var.second_to_first_name
  virtual_network_name         = var.second_virtual_network_name
  remote_virtual_network_id    = var.first_virtual_network_id
  resource_group_name          = var.resource_group_name
  allow_virtual_network_access = var.second_allow_virtual_network_access
  allow_forwarded_traffic      = var.second_allow_forwarded_traffic
  allow_gateway_transit        = var.second_allow_gateway_transit
}
