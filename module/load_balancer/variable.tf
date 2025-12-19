variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "frontend_ip" {
  type = string
}

variable "public_ip_address_id" {
  type = string
}

variable "backend_pool_name" {
  type = string
}

variable "probe_name" {
  type = string
}

variable "lb_rule_name" {
  type = string
}

variable "nic_ids" {
  type = map(string) 
}

variable "ip_configuration_name" {
  type = string
}
