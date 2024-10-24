data "azurerm_api_management" "this" {
  name                = local.apim_name
  resource_group_name = local.apim_rg
}

data "azurerm_resource_group" "workbook_rg" {
  name = var.monitor_resource_group_name
}

data "azurerm_subscription" "current" {}