variable "rgs" {
  type = map(object({
    name     = string
    location = string
  }))
}

variable "stgs" {
  type = map(object({
    name                     = string
    location                 = string
    resource_group_key       = string
    account_tier             = string
    account_replication_type = string
  }))
}

variable "vnets" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    address_space      = list(string)
    dns_servers        = list(string)
  }))
}

variable "subnets" {
  type = map(object({
    name               = string
    location           = string
    vnet_key           = string
    resource_group_key = string
    address_prefixes   = list(string)
  }))
}

variable "NICs" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    subnet_key         = string
    ip_name            = string
    public_ip_key      = string
  }))
}


variable "NSGs" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    security_rule = object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })
  }))
}

variable "public_ips" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    allocation_method  = string
  }))
}

variable "load_balancers" {
  type = map(object({
    lb_name               = string
    location              = string
    resource_group_key    = string
    frontend_ip           = string
    public_ip_key         = string
    backend_pool_name     = string
    probe_name            = string
    lb_rule_name          = string
    ip_configuration_name = string
    nic_key               = string
  }))
}


variable "vms" {
  type = map(object({
    name                 = string
    location             = string
    resource_group_key   = string
    nic_key              = string
    admin_username       = string
    admin_password       = string
    publisher            = string
    offer                = string
    sku                  = string
    version              = string
    size                 = string
    caching              = string
    storage_account_type = string
  }))
}

