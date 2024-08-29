locals {
  apim_monitor_api = {
    display_name          = "Monitor"
    description           = "Monitor API"
    path                  = ""
    subscription_required = false
    service_url           = null
  }
}

module "apim_api_monitor" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                = "${var.env_short}-monitor"
  api_management_name = local.apim_name
  resource_group_name = local.apim_rg
  protocols           = ["https"]

  product_ids           = [module.apim_monitor_product.product_id]
  subscription_required = local.apim_monitor_api.subscription_required
  description           = local.apim_monitor_api.description
  display_name          = local.apim_monitor_api.display_name
  path                  = local.apim_monitor_api.path
  service_url           = local.apim_monitor_api.service_url

  content_format = "openapi"
  content_value = templatefile("./api/monitor_openapi.json.tpl", {
    hostname = local.apim_hostname
  })

  xml_content = templatefile("./api/monitor_mock_policy.xml", {})
}