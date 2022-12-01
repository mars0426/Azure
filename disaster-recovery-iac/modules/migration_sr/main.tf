// Recovery Service
resource "azurerm_recovery_services_vault" "vault" {
  resource_group_name = var.secondary_resource_group_name
  name                = "example-recovery-vault"
  location            = var.secondary_location
  sku                 = "Standard"
}

resource "azurerm_site_recovery_fabric" "primary" {
  resource_group_name = var.secondary_resource_group_name
  name                = "primary-fabric"
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  location            = var.primary_location
}

resource "azurerm_site_recovery_fabric" "secondary" {
  resource_group_name = var.secondary_resource_group_name
  name                = "secondary-fabric"
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  location            = var.secondary_location
}

resource "azurerm_site_recovery_protection_container" "primary" {
  resource_group_name  = var.secondary_resource_group_name
  name                 = "primary-protection-container"
  recovery_vault_name  = azurerm_recovery_services_vault.vault.name
  recovery_fabric_name = azurerm_site_recovery_fabric.primary.name
}

resource "azurerm_site_recovery_protection_container" "secondary" {
  resource_group_name  = var.secondary_resource_group_name
  name                 = "secondary-protection-container"
  recovery_vault_name  = azurerm_recovery_services_vault.vault.name
  recovery_fabric_name = azurerm_site_recovery_fabric.secondary.name
}

resource "azurerm_site_recovery_replication_policy" "policy" {
  resource_group_name                                  = var.secondary_resource_group_name
  name                                                 = "policy"
  recovery_vault_name                                  = azurerm_recovery_services_vault.vault.name
  recovery_point_retention_in_minutes                  = 24 * 60
  application_consistent_snapshot_frequency_in_minutes = 4 * 60
}

resource "azurerm_site_recovery_protection_container_mapping" "container-mapping" {
  resource_group_name                       = var.secondary_resource_group_name
  name                                      = "container-mapping"
  recovery_vault_name                       = azurerm_recovery_services_vault.vault.name
  recovery_fabric_name                      = azurerm_site_recovery_fabric.primary.name
  recovery_source_protection_container_name = azurerm_site_recovery_protection_container.primary.name
  recovery_target_protection_container_id   = azurerm_site_recovery_protection_container.secondary.id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.policy.id
}

resource "azurerm_site_recovery_network_mapping" "network-mapping" {
  resource_group_name         = var.secondary_resource_group_name
  name                        = "network-mapping"
  recovery_vault_name         = azurerm_recovery_services_vault.vault.name
  source_recovery_fabric_name = azurerm_site_recovery_fabric.primary.name
  target_recovery_fabric_name = azurerm_site_recovery_fabric.secondary.name
  source_network_id           = var.source_network_id
  target_network_id           = var.target_network_id
}

resource "azurerm_storage_account" "primary" {
  resource_group_name      = var.primary_resource_group_name
  name                     = "primaryrecoverycachemars"
  location                 = var.primary_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_site_recovery_replicated_vm" "vm-replication" {
  resource_group_name                       = var.secondary_resource_group_name
  name                                      = "vm-replication"
  recovery_vault_name                       = azurerm_recovery_services_vault.vault.name
  source_recovery_fabric_name               = azurerm_site_recovery_fabric.primary.name
  source_vm_id                              = var.source_vm_id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.policy.id
  source_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary.name

  target_resource_group_id                = var.secondary_resource_group_id
  target_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary.id
  target_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary.id

  managed_disk {
    disk_id                    = var.source_disk_id
    staging_storage_account_id = azurerm_storage_account.primary.id
    target_resource_group_id   = var.secondary_resource_group_id
    target_disk_type           = "Premium_LRS"
    target_replica_disk_type   = "Premium_LRS"
  }

  network_interface {
    source_network_interface_id   = var.source_network_interface_id
    target_subnet_name            = var.target_subnet_name
    //recovery_public_ip_address_id = module.secondary_public_ip.id
  }

  depends_on = [
    azurerm_site_recovery_protection_container_mapping.container-mapping,
    azurerm_site_recovery_network_mapping.network-mapping,
  ]
}