variable "resource_group_name" {}
variable "name" {
  default = "example-nic"
}
variable "location" {
  default = "Japan East"
}
variable "subnet_id" {}
variable "tags" {
  default = {
    department = "RD"
    owner      = "Mars Wang"
  }
}
