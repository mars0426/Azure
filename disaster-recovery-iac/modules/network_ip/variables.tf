variable "name" {}
variable "resource_group_name" {}
variable "location" {
  default = "Japan East"
}
variable "allocation_method" {
  default = "Static"
}
variable "sku" {
  default = "Basic"
}
variable "tags" {
  default = {
    department = "RD"
    owner      = "Mars Wang"
  }
}
