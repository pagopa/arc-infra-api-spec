resource "azurerm_api_management_group" "cittadini_group" {
  name                = var.domain
  resource_group_name = data.azurerm_api_management.this.resource_group_name
  api_management_name = data.azurerm_api_management.this.name
  display_name        = upper(var.domain)
}

module "apim_cittadini_product" {
  source = "./.terraform/modules/__v3__/api_management_product"

  product_id   = "${var.prefix}-${var.domain}"
  display_name = "Cittadini API Product"
  description  = ""

  api_management_name = local.apim_name
  resource_group_name = local.apim_rg

  published             = false
  subscription_required = false
  approval_required     = false
  subscriptions_limit   = 0

  policy_xml = templatefile("./api_product/_base_policy.xml", {
    fe_origin    = local.fe_hostname
    local_origin = contains(["d", "u"], var.env_short) ? "\n<origin>http://localhost:1234</origin>" : ""
  })
}
