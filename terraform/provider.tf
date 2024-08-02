terraform {
  required_version = ">= 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "3.103.1"
    }
  }
#    backend "azurerm" {
#      resource_group_name  = "learnterraform"
#      storage_account_name = "terraformtmcmm"
#      container_name       = "tfstate"
#      access_key = "(...)"
#      key = "codelab.microsoft.tfstate" 
#    }

}

provider "azurerm" {
  subscription_id = var.subscription_id
  # Tenant Id for the terraform SP
  tenant_id       = var.tenant_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
   }
  }
}
