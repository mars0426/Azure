variable "name" {
  default = "example-network-security-group"
}
variable "resource_group_name" {}
variable "location" {
  default = "Japan East"
}
variable "tags" {
  default = {
    department = "RD"
    owner      = "Mars Wang"
  }
}
