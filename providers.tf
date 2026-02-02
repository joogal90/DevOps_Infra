terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "4f745e59-7394-4e4f-be89-96b2457d289c"
}