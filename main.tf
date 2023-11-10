terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "azure_storage_account_data_deletion_or_corruption" {
  source    = "./modules/azure_storage_account_data_deletion_or_corruption"

  providers = {
    shoreline = shoreline
  }
}