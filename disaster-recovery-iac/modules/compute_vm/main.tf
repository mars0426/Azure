resource "azurerm_windows_virtual_machine" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    var.network_interface_id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = var.tags
}

data "azurerm_managed_disk" "os_disk" {
  name                = azurerm_windows_virtual_machine.example.os_disk[0].name
  resource_group_name = azurerm_windows_virtual_machine.example.resource_group_name
}
