variable "resource_group_name" {}
variable "name" {}
variable "address_space" {}
variable "subnet_address_prefix" {}
variable "location" {
  default = "Japan East"
}
variable "tags" {
  default = {
    department = "RD"
    owner      = "Mars Wang"
  }
}
