variable "name" {
  default = "example-machine"
}
variable "resource_group_name" {}
variable "location" {
  default = "Japan East"
}
variable "size" {
  default = "Standard_D4as_v5"
}
variable "admin_username" {}
variable "admin_password" {}
variable "network_interface_id" {}
variable "tags" {
  default = {
    department = "RD"
    owner      = "Mars Wang"
  }
}
