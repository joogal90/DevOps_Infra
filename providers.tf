terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "4.57.0"
        }
    }
    backend "azurerm" {
      resource_group_name = "rock_backend-Jugal"
      storage_account_name = "rockbackend1"
      container_name = "tfstate"
      key = "dev.terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
  subscription_id = "4f745e59-7394-4e4f-be89-96b2457d289c"

}
