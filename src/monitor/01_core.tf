resource "azurerm_api_management_group" "monitor_group" {
  name                = var.domain
  resource_group_name = data.azurerm_api_management.this.resource_group_name
  api_management_name = data.azurerm_api_management.this.name
  display_name        = upper(var.domain)
}

module "apim_monitor_product" {
  source = "./.terraform/modules/__v3__/api_management_product"

  product_id   = "${var.prefix}-${var.domain}"
  display_name = "MONITOR API Product"
  description  = ""

  api_management_name = local.apim_name
  resource_group_name = local.apim_rg

  published             = false
  subscription_required = false
  approval_required     = false
  subscriptions_limit   = 0

  policy_xml = file("./api_product/monitor_base_policy.xml")
}

module "apim_api_cittadini_v1" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${var.env_short}-monitor"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_monitor_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = ""
  display_name = "Monitor"
  path         = ""
  protocols    = ["https"]
  service_url  = null

  content_format = "openapi"
  content_value = templatefile("./api/monitor_openapi.json.tpl", {
    hostname = local.apim_hostname
  })

  xml_content = templatefile("./api/monitor_mock_policy.xml", {})
}
