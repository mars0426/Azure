variable "primary_resource_group_name" {}
variable "secondary_resource_group_name" {}
variable "secondary_resource_group_id" {}
variable "primary_location" {
  default = "Japan East"
}
variable "secondary_location" {
  default = "Southeast Asia"
}
variable "source_network_id" {}
variable "target_network_id" {}
variable "source_vm_id" {}
variable "source_disk_id" {}
variable "source_network_interface_id" {}
variable "target_subnet_name" {}