output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].host
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
}

output "client_key" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "kubelet_identity_object_id" {
  description = "Object ID of the AKS cluster's kubelet managed identity"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}