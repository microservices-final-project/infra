output "resource_group_name" {
  description = "The Resource Group Name"
  value       = azurerm_resource_group.microservices_rg.name
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_host" {
  description = "The host URL for the AKS cluster"
  value       = module.aks.host
  sensitive   = true
}

output "aks_client_certificate" {
  description = "The client certificate for the AKS cluster"
  value       = module.aks.client_certificate
  sensitive   = true
}

output "aks_client_key" {
  description = "The client key for the AKS cluster"
  value       = module.aks.client_key
  sensitive   = true
}

output "aks_cluster_ca_certificate" {
  description = "The CA certificate for the AKS cluster"
  value       = module.aks.cluster_ca_certificate
  sensitive   = true
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.microservices_acr.name
}

output "acr_login_server" {
  description = "Login server URL of the Azure Container Registry"
  value       = azurerm_container_registry.microservices_acr.login_server
}

output "acr_admin_username" {
  description = "Admin username for the Azure Container Registry"
  value       = azurerm_container_registry.microservices_acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Admin password for the Azure Container Registry"
  value       = azurerm_container_registry.microservices_acr.admin_password
  sensitive   = true
}
