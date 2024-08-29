terraform {
  required_version = ">=1.3.0"

  required_providers {
    zuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.52"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.108"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.39.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=e64f39b63d46e8c05470e30eca873f44a0ab7f1b"
}
