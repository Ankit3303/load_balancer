module "rgs" {
  source   = "../module/resource_group"
  for_each = var.rgs
  name     = each.value.name
  location = each.value.location
}

module "stgs" {
  source                   = "../module/storage_account"
  for_each                 = var.stgs
  depends_on               = [module.rgs]
  name                     = each.value.name
  location                 = each.value.location
  resource_group_name      = module.rgs[each.value.resource_group_key].rg_name
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}

module "vnets" {
  source              = "../module/virtual_network"
  for_each            = var.vnets
  depends_on          = [module.rgs]
  name                = each.value.name
  location            = each.value.location
  resource_group_name = module.rgs[each.value.resource_group_key].rg_name
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
}

module "subnets" {
  source               = "../module/subnet"
  for_each             = var.subnets
  depends_on           = [module.vnets]
  name                 = each.value.name
  location             = each.value.location
  virtual_network_name = module.vnets[each.value.vnet_key].vnet_name
  resource_group_name  = module.rgs[each.value.resource_group_key].rg_name
  address_prefixes     = each.value.address_prefixes
}

module "NICs" {
  source                = "../module/NIC"
  for_each              = var.NICs
  depends_on            = [module.subnets, module.public_ips]
  name                  = each.value.name
  location              = each.value.location
  resource_group_name   = module.rgs[each.value.resource_group_key].rg_name
  subnet_id             = module.subnets[each.value.subnet_key].id
  ip_configuration_name = each.value.ip_name
}


module "NSGs" {
  source         = "../module/NSG"
  for_each       = var.NSGs
  depends_on     = [module.subnets]
  name           = each.value.name
  location       = each.value.location
  resource_group = module.rgs[each.value.resource_group_key].rg_name

}

module "public_ips" {
  source              = "../module/public_ip"
  for_each            = var.public_ips
  name                = each.value.name
  location            = each.value.location
  resource_group_name = module.rgs[each.value.resource_group_key].rg_name
  allocation_method   = each.value.allocation_method
}
module "load_balancers" {
  source     = "../module/load_balancer"
  for_each   = var.load_balancers
  depends_on = [module.NICs, module.public_ips]

  name                  = each.value.lb_name
  location              = each.value.location
  resource_group_name   = module.rgs[each.value.resource_group_key].rg_name
  frontend_ip           = each.value.frontend_ip
  public_ip_address_id  = module.public_ips[each.value.public_ip_key].id
  backend_pool_name     = each.value.backend_pool_name
  probe_name            = each.value.probe_name
  lb_rule_name          = each.value.lb_rule_name
  ip_configuration_name = each.value.ip_configuration_name

  nic_ids = {
    (each.value.nic_key) = module.NICs[each.value.nic_key].id
  }
}



module "vms" {
  source               = "../module/virtual_machine"
  for_each             = var.vms
  depends_on           = [module.subnets, module.NICs]
  name                 = each.value.name
  location             = each.value.location
  resource_group_name  = module.rgs[each.value.resource_group_key].rg_name
  network_interface_id = module.NICs[each.value.nic_key].id
  admin_username       = each.value.admin_username
  admin_password       = each.value.admin_password
  publisher            = each.value.publisher
  offer                = each.value.offer
  sku                  = each.value.sku

  image_version        = "v1.0"
  size                 = each.value.size
  caching              = each.value.caching
  storage_account_type = each.value.storage_account_type
}


