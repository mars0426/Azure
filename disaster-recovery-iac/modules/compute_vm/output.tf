output "id" {
  value = azurerm_windows_virtual_machine.example.id
}
output "managed_disk_id" {
  value = data.azurerm_managed_disk.os_disk.id
}
