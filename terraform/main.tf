resource "random_id" "acr_suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "microservices_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "identity" {
  name                = "identity"
  resource_group_name = azurerm_resource_group.microservices_rg.name
  location            = azurerm_resource_group.microservices_rg.location
}


resource "azurerm_container_registry" "microservices_acr" {
  name                = "microservicesacr${random_id.acr_suffix.hex}"
  resource_group_name = azurerm_resource_group.microservices_rg.name
  location            = azurerm_resource_group.microservices_rg.location
  sku                  = "Basic"
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.microservices_acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}


module "aks" {
  source              = "./modules/aks"
  cluster_name        = var.cluster_name
  location            = azurerm_resource_group.microservices_rg.location
  resource_group_name = azurerm_resource_group.microservices_rg.name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  vm_size             = var.vm_size
  tags                = var.tags
  user_assigned_identity_id = azurerm_user_assigned_identity.identity.id

}

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_namespace" "stage" {
  metadata {
    name = "stage"
  }
}

resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}

terraform {
  backend "s3" {
    bucket  = "microservices-state-bucket"
    key     = "terraform/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}