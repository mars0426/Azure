# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Create primary resource group
module "primary_resource_group" {
  source = "./modules/management_rg"
  name     = "${var.prefix}-primary-RG"
  location = var.primary_location
}

# Create secondary resource group
module "secondary_resource_group" {
  source = "./modules/management_rg"
  name     = "${var.prefix}-secondary-RG"
  location = var.secondary_location
}

# Create primary virtual network
module "primary_virtual_network" {
  source                = "./modules/network_vnet"
  resource_group_name   = module.primary_resource_group.name
  name                  = "${var.prefix}-primary-VNET"
  location              = var.primary_location
  address_space         = ["10.0.0.0/16"]
  subnet_address_prefix = ["10.0.0.0/24"]
}

# Create secondary network
module "secondary_virtual_network" {
  source                = "./modules/network_vnet"
  resource_group_name   = module.secondary_resource_group.name
  name                  = "${var.prefix}-secondary-VNET"
  location              = var.secondary_location
  address_space         = ["10.1.0.0/16"]
  subnet_address_prefix = ["10.1.0.0/24"]
}

# Create network interface
module "network_interface" {
  source              = "./modules/network_nic"
  resource_group_name = module.primary_resource_group.name
  location            = var.primary_location
  subnet_id           = module.primary_virtual_network.subnet_id
}

module "windows_virtual_machine" {
  source               = "./modules/compute_vm"
  resource_group_name  = module.primary_resource_group.name
  location             = var.primary_location
  admin_username       = "mars"
  admin_password       = "Coc@c0laP@ssw0rd"
  network_interface_id = module.network_interface.id
}

module "site_recovery" {
  source = "./modules/migration_sr"
  primary_resource_group_name = module.primary_resource_group.name
  secondary_resource_group_name = module.secondary_resource_group.name
  secondary_resource_group_id = module.secondary_resource_group.id
  primary_location = var.primary_location
  secondary_location = var.secondary_location
  source_network_id = module.primary_virtual_network.id
  target_network_id = module.secondary_virtual_network.id
  source_vm_id = module.windows_virtual_machine.id
  source_disk_id = module.windows_virtual_machine.managed_disk_id
  source_network_interface_id = module.network_interface.id
  target_subnet_name = module.secondary_virtual_network.subnet_name
}
