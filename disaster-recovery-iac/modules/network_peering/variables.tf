variable "resource_group_name" {}

variable "first_to_second_name" {
  default = "first-to-second"
}
variable "first_virtual_network_name" {}
variable "first_virtual_network_id" {}
variable "first_allow_virtual_network_access" {
  default = true
}
variable "first_allow_forwarded_traffic" {
  default = false
}
variable "first_allow_gateway_transit" {
  default = false
}

variable "second_to_first_name" {
  default = "second-to-first"
}
variable "second_virtual_network_name" {}
variable "second_virtual_network_id" {}
variable "second_allow_virtual_network_access" {
  default = true
}
variable "second_allow_forwarded_traffic" {
  default = false
}
variable "second_allow_gateway_transit" {
  default = false
}
