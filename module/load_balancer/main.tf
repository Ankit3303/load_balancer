resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = var.frontend_ip
    public_ip_address_id = var.public_ip_address_id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend" {
  name            = var.backend_pool_name
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "lb_probe" {
  name                = var.probe_name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_assoc" {
  for_each = var.nic_ids 

  network_interface_id    = each.value
  ip_configuration_name   = var.ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend.id
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = var.lb_rule_name
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = var.frontend_ip
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  floating_ip_enabled             = false
  idle_timeout_in_minutes        = 4
}
