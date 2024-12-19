provider "azurerm" {
  features {}
}

provider "azuread" {
  use_msi   = true
  tenant_id = "576d634f-7729-4278-9174-4ed588ee532a"
}