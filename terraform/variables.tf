variable "cluster_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "dns_prefix" {}
variable "node_count" {
  default = 1
}
variable "vm_size" {
  default = "Standard_DS2_v2"
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "subscription_id" {
  description = "The ID of the Azure subscription where the resources will be created."
  type        = string
}