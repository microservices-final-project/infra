resource "random_id" "acr_suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "microservices_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "microservices_acr" {
  name                = "microservicesacr${random_id.acr_suffix.hex}"
  resource_group_name = azurerm_resource_group.microservices_rg.name
  location            = azurerm_resource_group.microservices_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

module "aks" {

  source = "./modules/aks"

  for_each = {

    dev = {
      location     = "West US"
      cluster_name = "${var.cluster_name}-dev"
      dns_prefix   = "${var.dns_prefix}-dev"
      node_count   = 2
      vm_size      = "Standard_B2s"
      tags = {
        environment = "dev"
        project     = "microservices"
      }
    }

    stage = {
      location     = "East US"
      cluster_name = "${var.cluster_name}-stage"
      dns_prefix   = "${var.dns_prefix}-stage"
      node_count   = 2
      vm_size      = "Standard_B2s"
      tags = {
        environment = "stage"
        project     = "microservices"
      }
    }

    # prod = {
    #   cluster_name = "${var.cluster_name}-prod"
    #   dns_prefix   = "${var.dns_prefix}-prod"
    #   node_count   = 2
    #   vm_size      = "Standard_DS2_v2"
    #   tags = {
    #     environment = "prod"
    #     project     = "microservices"
    #   }
    # }

  }
  location            = each.location
  cluster_name        = each.cluster_name
  resource_group_name = azurerm_resource_group.microservices_rg.name
  dns_prefix          = each.dns_prefix
  node_count          = each.node_count
  vm_size             = each.vm_size
  tags                = eacb.tags
}

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

terraform {
  backend "s3" {
    bucket  = "microservices-state-bucket"
    key     = "terraform/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}
