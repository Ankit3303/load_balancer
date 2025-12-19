output "id" {
  value = azurerm_lb.lb.id
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.lb_backend.id
}

output "frontend_ip_name" {
  value = azurerm_lb.lb.frontend_ip_configuration[0].name
}
